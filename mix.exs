defmodule MonorepoExample.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
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
end
