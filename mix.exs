defmodule ExConf.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_conf,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:credo, "~> 0.3", only: [:dev, :test]}
    ]
  end
end
