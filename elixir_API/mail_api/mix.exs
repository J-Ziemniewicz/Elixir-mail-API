defmodule MailApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :mail_api,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy, :bamboo, :bamboo_smtp],
      mod: {MailApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:plug_cowboy, "~> 2.0"},
      {:bamboo, "~> 1.5"},
      {:bamboo_smtp, "~> 2.1.0"}
    ]
  end
end
