defmodule EarmarkGfm.Mixfile do
  use Mix.Project

  @version "0.0.0"

  @url "https://github.com/robertdober/gearmark"

  @deps [
    {:dialyxir, "~> 1.4.5", only: [:dev]},
    {:ex_aequo, "~> 0.6.8", only: [:dev]},
    {:excoveralls, "~> 0.18.3", only: [:test]},
    {:floki, "~> 0.36.3", only: [:dev, :test]}
    # {:benchfella, "~> 0.3.0", only: [:dev]},
    # {:extractly, "~> 0.5.3", only: [:dev]},
  ]

  @description """
  Gearmark is a pure-Elixir Markdown Parser.

  As the name implies it is thought as a replacement or logical
  evolutaion of Earmark.

  It supports Github Flavored Markdown as it has become the defacto
  standard for Elixir developpers. EarmarkParser is too complicated
  to refactor into GFM compliance, hence this library, which will
  create a GFM compliant AST **from start**
  """

  ############################################################

  def project do
    [
      app: :earmark_gfm,
      version: @version,
      compilers: [:leex, :yecc] ++ Mix.compilers(),
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      # escript: escript_config(), # Maybe later, maybe not
      deps: @deps,
      description: @description,
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      test_coverage: [tool: ExCoveralls],
      aliases: [
        docs: &build_docs/1,
        mk_specs: &mk_specs/1,
      ],
    ]
  end

  def application do
    [
      extra_applications: [:eex]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support", "dev"]
  defp elixirc_paths(:dev), do: ["lib", "dev"]
  defp elixirc_paths(_), do: ["lib"]

  # defp escript_config do
  #   [main_module: EarmarkGfm.Cli]
  # end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "README.md"
      ],
      maintainers: [
        "Robert Dober <robert.dober@gmail.com>",
      ],
      licenses: [
        "Apache-2.0"
      ],
      links: %{
        "GitHub" => @url
      }
    ]
  end

  @prerequisites """
  run `mix escript.install hex ex_doc` and adjust `PATH` accordingly
  """
  defp build_docs(_) do
    Mix.Task.run("compile")
    ex_doc = Path.join(Mix.path_for(:escripts), "ex_doc")
    Mix.shell().info("Using escript: #{ex_doc} to build the docs")

    unless File.exists?(ex_doc) do
      raise "cannot build docs because escript for ex_doc is not installed, make sure to \n#{@prerequisites}"
    end

    args = ["EarmarkGfm", @version, Mix.Project.compile_path()]
    opts = ~w[--main EarmarkGfm --source-ref v#{@version} --source-url #{@url}]

    Mix.shell().info("Running: #{ex_doc} #{inspect(args ++ opts)}")
    System.cmd(ex_doc, args ++ opts)
    Mix.shell().info("Docs built successfully")
  end

  defp mk_specs(args) do
    Mix.Task.run("compile")
    Dev.MkSpecs.run(args)
  end
end

# SPDX-License-Identifier: Apache-2.0
