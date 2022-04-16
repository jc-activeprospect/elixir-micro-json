defmodule WebhookProcessor.MixProject do
  use Mix.Project

  def project do
    [
      app: :webhook_processor,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {WebhookProcessor.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"}, # This will pull in Plug AND Cowboy
      {:poison, "~> 3.1"} # Latest version as of this writing
    ]
  end
end
