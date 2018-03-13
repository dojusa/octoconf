defmodule Octoconf.Mixfile do
  use Mix.Project

  def project do
    [
      app: :octoconf,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Octoconf, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.0"},
      {:ex_aws_sqs, "~> 2.0"},
      {:sweet_xml, "~> 0.6.5"},
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:gen_stage, "~> 0.13.1"},
      {:uuid, "~> 1.1"},
      {:swarm, "~> 3.3"},
    ]
  end
end
