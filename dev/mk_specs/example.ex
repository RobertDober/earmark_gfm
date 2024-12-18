defmodule Dev.MkSpecs.Example do
  alias ExAequoColors.Ui

  import Dev.MkSpecs.List, only: [join_numbered_lines: 1, take_and_rest: 2]

  @moduledoc ~S"""
  Represents an example in a kind of AST and exposes the parsing functions
  """

  defstruct markdown: [], html: "", ast: [], example_number: 0

  def new({lines, idx}) do
    example_number = idx + 1
    {:ok, {markdown_list, html_list}} = take_and_rest(lines, ".")
    {markdown, md_lnb} = join_numbered_lines(markdown_list)
    {html, html_lnb} = join_numbered_lines(html_list)

    if markdown == [] do
      Ui.error("empty markdown part in example ##{example_number}")
    else
      if html == [] do
        Ui.error("empty html part in example ##{example_number}}")
      else
        _new(markdown, html, idx + 1)
      end
    end
  end

  defp _new(markdown, html, example_number) do
    ast = case Floki.parse_fragment(html) do
      {:ok, ast} -> ast
      error ->
        UI.error("incorrect HTML in example ##{example_number}:\n<bold>#{html}")
        nil
    end
    %__MODULE__{markdown: markdown, html: html, ast: ast}
  end
end

# SPDX-License-Identifier: Apache-2.0
