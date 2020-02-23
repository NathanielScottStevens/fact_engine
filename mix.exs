defmodule FactEngine.MixProject do
  use Mix.Project

  def project do
    [
      app: :fact_engine,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: FactEngine],
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      build: ["deps.get", "escript.build"],
      exec: ["cmd ./fact_engine"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev], runtime: false},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end
end
