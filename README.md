# MonorepoExample

## Building independent images from a monorepo

Please note this umbrella project / repo defines two releases:

```
  defp releases do
    [
      service_c: ...,
      service_d: ...
    ]
  end
```

And a `Dockerfile` flexible enough to containerize each release independently.

Building a release container image:

```
docker buildx build --build-arg APP_NAME=<release-name> -t <release-container-tag> .
```

For example:

```
docker buildx build --build-arg APP_NAME=service_c -t monorepo_service_c:latest .
docker buildx build --build-arg APP_NAME=service_d -t monorepo_service_d:latest .
```

We can also use the alias defined in `mix.exs` to build all the release
container images defined in this repo:

```
mix docker.build
```

Check out `config/runtime.exs` and [Direnv](https://direnv.net/) `.envrc` to see how
to achieve independent configuration of each of the release containers.

How can we tell that two distinct releases were actually built?

```
$ docker run --rm -it \
  --env MONOREPO_RELEASE_APP=service_c \
  --env MONOREPO_SERVICE_C_OPTION=${MONOREPO_SERVICE_C_OPTION} \
  docker.io/library/monorepo_service_c:latest start_iex
Erlang/OTP 25 [erts-13.2.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]

Interactive Elixir (1.13.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(service_c@63ce91c04b00)1> Application.started_applications()
[
  ...
  {:service_c, 'service_c', '0.1.0'},
  {:lib_a, 'lib_a', '0.1.0'},
  ...
]
iex(service_c@63ce91c04b00)2> Application.get_all_env(:service_c)
[service_c_option: "service-c-val"]
iex(service_c@63ce91c04b00)2> Application.get_all_env(:service_d)
[]
```

```
$ docker run --rm -it \
  --env MONOREPO_RELEASE_APP=service_d \
  --env MONOREPO_SERVICE_D_OPTION=${MONOREPO_SERVICE_D_OPTION} \
  docker.io/library/monorepo_service_d:latest start_iex
Erlang/OTP 25 [erts-13.2.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]

Interactive Elixir (1.13.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(service_d@6573325de339)1> Application.started_applications()
[
  ...
  {:service_d, 'service_d', '0.1.0'},
  {:lib_b, 'lib_b', '0.1.0'},
  ...
]
iex(service_d@6573325de339)1> Application.get_all_env(:service_c)
[]
iex(service_d@6573325de339)1> Application.get_all_env(:service_d)
[service_d_option: "service-d-val"]
```
