# MonorepoExample

## Building independent images from a monorepo

Please note this umbrella project / repo defines two releases:

```
  defp releases do
    [
      app_c: ...,
      app_d: ...
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
docker buildx build --build-arg APP_NAME=app_c -t monorepo-app-c:latest .
docker buildx build --build-arg APP_NAME=app_d -t monorepo-app-d:latest .
```

How can we tell that two distinct releases were actually built?

```
$ docker run --rm -it docker.io/library/monorepo-app-c:latest start_iex
Erlang/OTP 25 [erts-13.2.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]

Interactive Elixir (1.13.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(app_c@63ce91c04b00)1> Application.started_applications()
[
  ...
  {:app_c, 'app_c', '0.1.0'},
  {:app_a, 'app_a', '0.1.0'},
  ...
]
iex(app_c@63ce91c04b00)2>
```

```
$ docker run --rm -it docker.io/library/monorepo-app-d:latest start_iex
Erlang/OTP 25 [erts-13.2.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]

Interactive Elixir (1.13.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(app_d@6573325de339)1> Application.started_applications()
[
  ...
  {:app_d, 'app_d', '0.1.0'},
  {:app_b, 'app_b', '0.1.0'},
  ...
]
iex(app_d@6573325de339)2>
```


## Using this repo as a template

You can use this repo as a template to scaffold a new umbrella project.
Just clone it, `git reset --hard` to the last relevant commit (e.g. 6b352a5),
and adjust the README as well as all occurences of `monorepo` to your liking.
