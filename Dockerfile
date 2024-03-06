ARG ELIXIR_VERSION=1.15.2
ARG OTP_VERSION=25.3.2.3
ARG ALPINE_VERSION=3.16.6

ARG BUILDER_IMAGE=hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-alpine-${ALPINE_VERSION}
ARG RUNNER_IMAGE=alpine:${ALPINE_VERSION}

FROM ${BUILDER_IMAGE} AS builder

# ssh
RUN apk upgrade --no-cache && apk add --no-cache --update build-base git openssh-client
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Always set the env to prod
ENV MIX_ENV=prod

# The following are build arguments used to change variable parts of the image.
# The name of your application/release (required)
ARG APP_NAME

# By convention, /opt is typically used for applications
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN mix local.rebar --force && \
  mix local.hex --force

# Cache the dependency fetching
COPY mix.exs mix.exs

# Cache the dependency fetching
#COPY mix.lock mix.lock

COPY config config

RUN --mount=type=ssh mix do deps.get --only $MIX_ENV, deps.compile

COPY apps apps

RUN MIX_ENV=prod mix compile

ARG APP_VSN

ENV APP_VSN=${APP_VSN}

RUN mix release ${APP_NAME}

# From this line onwards, we're in a new image, which will be the image used in production
FROM ${RUNNER_IMAGE} AS final
RUN apk upgrade --no-cache && \ 
  apk add --no-cache bash openssl libgcc libstdc++ ncurses-libs

ARG APP_NAME

WORKDIR /opt/app

COPY --from=builder /opt/app/_build/prod/rel/${APP_NAME}*  .

RUN find /opt/app -type f -perm +0100 -exec chmod 555 {} \;

RUN cp ./bin/${APP_NAME} ./bin/release

ENTRYPOINT  ["./bin/release"]

CMD ["start"]

