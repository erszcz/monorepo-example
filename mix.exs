defmodule MonorepoExample.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: releases()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    []
  end

  defp releases do
    [
      app_c: [
        include_executables_for: [:unix],
        applications: [app_c: :permanent]
      ],
      app_d: [
        include_executables_for: [:unix],
        applications: [app_d: :permanent]
      ]
    ]
  end

  defp aliases do
    [
      "docker.build": [&docker_build/1]
    ]
  end

  defp docker_build(releases_to_build) do
    defined_releases = releases() |> Keyword.keys() |> Enum.map(&to_string(&1))

    Enum.each(releases_to_build, fn rel ->
      unless rel in defined_releases do
        raise "unknown release: #{rel}"
      end
    end)

    releases_to_build = releases_to_build == [] && defined_releases || releases_to_build

    Enum.each(releases_to_build, fn rel ->
      Mix.shell().cmd(
        "docker buildx build --build-arg APP_NAME=#{rel} -t monorepo_#{rel}:latest ."
      )
    end)
  end
end
