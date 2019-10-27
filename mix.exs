defmodule CloudAPI.Mixfile do
  use Mix.Project

  @project_url "https://github.com/fbettag/cloudapi"

  def project do
    [
      app:              :cloudapi,
      version:          "0.0.1",
      elixir:           "~> 1.4",
      source_url:       @project_url,
      homepage_url:     @project_url,
      name:             "Joyent CloudAPI implemented in Elixir and Poison",
      description:      "This package implements the full CloudAPI for managing Joyent Triton clusters.",
      build_embedded:   Mix.env == :prod,
      start_permanent:  Mix.env == :prod,
      package:          package(),
      deps:             deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:poison,       "~> 4.0.1"},
      {:httpoison,    "~> 1.6"},
      {:ecto,         "~> 3.0"},
      {:ex_doc,       "~> 0.19", only: :dev}
    ]
  end

  defp package do
    [
      name:         "cloudapi",
      maintainers:  ["Franz Bettag"],
      licenses:     ["MIT"],
      links:        %{"GitHub" => @project_url}
    ]
  end
end
