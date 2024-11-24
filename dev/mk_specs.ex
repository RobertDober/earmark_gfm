defmodule Dev.MkSpecs do
  @moduledoc ~S"""
  Generate specs and the according tests from the file test/spec.txt which
  is defined [here](https://github.com/github/cmark-gfm/blob/master/test/spec.txt)

  **TODO** Greate a procedure to check if the file is up to date, reload and
  regenerate the specs and tests if applicable.
  """

  @spec "test/specs_test.exs"
  @gfm_specs "test/spec.txt" 

  def run(_args) do
    case check_date do
      :ok ->
        col([
          "<green,bold>Info:$ Specs #{@specs} are up to date (newer than #{@gfm_specs})",
          "<underline>Nothuing to be done"
        ])

      _ ->
        col("<yellow,bold>Coming Soon")
    end
  end

  defp check_date do
    case File.lstat("test/spec_test.exs") do
      ta
    end
  end

  defp col(str_or_list)

  defp col(list) when is_list(list) do
    list
    |> Enum.each(&col/1)
  end

  defp col(str), do: ExAequo.Color.colorize(str, reset: true) |> IO.puts()
end

# SPDX-License-Identifier: Apache-2.0
