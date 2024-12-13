defmodule Dev.MkSpecs.MakeSpecs do
  alias ExAequoColors.Ui

  @moduledoc ~S"""
  Parse  specs.txt into a test script
  """


  @expected_example_count 672
  def make_specs(spec) do
    Ui.info("Starting reading spec file: #{spec}", device: :stderr)
    spec
    |> File.stream!(:line)
    |> Stream.map(&String.trim_trailing(&1, "\n"))
    |> Stream.with_index
    |> parse()
  end

  defp parse(io) do
    examples = partition_list(io, &outside?/1, &inside?/1)
    c = Enum.count(examples)
    if c == @expected_example_count do
      Ui.info("#{c} examples found, that seems ok!", device: :stderr)
    else
      Ui.warning("#{c} examples found, <bold>#{@expected_example_count} expected$ <cyan>Chek if specs have evolved!", device: :stderr)
    end
  end

  defp partition_list(list, out_f, in_f, result \\ [])
  defp partition_list(list, out_f, in_f, result) do
    case Enum.drop_while(list, out_f) do
      [] -> result |> Enum.reverse
      [{_, lnb}|rest] ->
        {rest1, example} = get_example(lnb, rest, in_f)
        partition_list(rest1, out_f, in_f, [example|result])
    end
  end

  defp get_example(lnb, list, in_f, example \\ [])
  defp get_example(lnb, [], _, example) do
    Ui.warning("missing end of example, at end of input, example started at line: #{lnb}")
    example |> Enum.reverse
  end
  defp get_example(lnb, [line|rest], in_f, example) do
    if in_f.(line) do
      get_example(lnb, rest, in_f, [line|example])
    else
      {rest, example |> Enum.reverse}
    end
  end

  @end_example_rgx ~r/\A `{32} \s* \z/x
  defp inside?({line, _lnb}) do
    !Regex.match?(@end_example_rgx, line)
  end
  @start_example_rgx ~r/\A `{32} \s example/x
  defp outside?({line, _lnb}) do
    !Regex.match?(@start_example_rgx, line)
  end
end
# SPDX-License-Identifier: Apache-2.0
