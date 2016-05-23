defmodule Confex.Mixfile do
  use Mix.Project

  def project do
    [app: :confex,
     version: "0.1.0",
     elixir: "~> 1.2",
     consolidate_protocols: Mix.env != :test,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger, :yamerl]]
  end

  def description do
    """
    Confex is a library for handling configuration in an environment with multiple
    overlapping sources of data. Confex is designed to make it easy to compose
    multiple sources into an ordered, hierarchical set of configuration data.
    """
  end

  def package do
    [
      files: [],
      maintainers: ["Stuart Childs"],
      licenses: ["MIT"],
      links: %{ "GitHub": "https://github.com/childss/confex" }
    ]
  end

  defp deps do
    [
      {:yaml_elixir, "~> 1.0.0"},
      {:yamerl, github: "yakaz/yamerl", tag: "v0.3.2-1"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:credo, "~> 0.3", only: [:dev, :test]}
    ]
  end
end
