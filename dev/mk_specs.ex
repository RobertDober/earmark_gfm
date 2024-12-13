defmodule Dev.MkSpecs do
  @moduledoc ~S"""
  Generate specs and the according tests from the file test/spec.txt which
  is defined [here](https://github.com/github/cmark-gfm/blob/master/test/spec.txt)

  **TODO** Greate a procedure to check if the file is up to date, reload and
  regenerate the specs and tests if applicable.
  """

  alias ExAequoColors.Ui
  import Dev.MkSpecs.MakeSpecs

  @specs "test/specs_test.exs"
  @gfm_specs "test/spec.txt" 

  def run(_args) do
    case check_date() do
      :ok ->
        col("""
          <green,bold>Info:$ Specs #{@specs} are up to date (newer than #{@gfm_specs})
          <underline>Nothing to be done
          """
        )

      {:error, message} -> Ui.error(message)
      _ ->
        make_specs(@gfm_specs)
    end
  end

  defp check_date do
    case get_time(@gfm_specs) do
      nil -> {
          :error,
          "Missing spec of GFM. It should be in <bold,yellow>#{@gfm_specs}$\nGet it from <underline>https://github.com/github/cmark-gfm/blob/master/test/spec.txt"
      }
      mtime -> compare_date(mtime)
    end
  end

  defp compare_date(specs_date) do
    case get_time(@specs) do
      nil -> :needed 
      mtime -> if mtime > specs_date, do: :ok, else: :needed
    end
  end

  defp col(str_or_list)

  defp col(list) when is_list(list) do
    list
    |> Enum.each(&col/1)
  end

  defp col(str), do: ExAequoColors.colorize(str, reset: true) |> IO.puts()

  defp get_time(path) do
    case File.lstat(path) do
      {:ok, %File.Stat{mtime: mtime}} -> mtime
      _  -> nil
    end
  end
end

# SPDX-License-Identifier: Apache-2.0
