defmodule CloudAPI.Mixfile do
  use Mix.Project

  @project_url "https://github.com/fbettag/cloudapi"

  def project do
    {tag, description} = git_version()
    [
      app:              :cloudapi,
      version:          tag,
      elixir:           "~> 1.4",
      source_url:       @project_url,
      homepage_url:     @project_url,
      name:             "Joyent CloudAPI",
      description:      "This package implements the full CloudAPI for managing Joyent Triton clusters " <> description,
      build_embedded:   Mix.env == :prod,
      start_permanent:  Mix.env == :prod,
      package:          package(),
      aliases:          aliases(),
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
      {:ex_doc,       "~> 0.19", only: :dev},
      {:credo,        github: "rrrene/credo", only: [:dev, :test]},
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

  defp aliases do
    [
      test: ["test", "credo -a --strict"],
      "hex.publish": ["test", "hex.publish"],
    ]
  end

  defp git_version() do
    # pulls version information from "nearest" git tag or sha hash-ish
    {hashish, 0} =
      System.cmd("git", ~w[describe --dirty --abbrev=7 --tags --always --first-parent])

    full_version = String.trim(hashish)

    tag_version =
      hashish
      |> String.split("-")
      |> List.first()
      |> String.replace_prefix("v", "")
      |> String.trim()

    tag_version =
      case Version.parse(tag_version) do
        :error -> "0.0.0-#{tag_version}"
        _ -> tag_version
      end

    {tag_version, full_version}
  end
end
