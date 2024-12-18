defmodule Dev.MkSpecs.List do
  @moduledoc ~S"""
  List helpers
  """

  def join_numbered_lines(lines, result \\ [], lnb \\ nil)
  def join_numbered_lines([{line, lnb}|rest], [], _), do: join_numbered_lines(rest, [line], lnb)
  def join_numbered_lines([{line, lnb}|rest], result, flnb), do: join_numbered_lines(rest, [line|result], flnb)
  def join_numbered_lines([], result, flnb), do: {result |> _replace_tabs(), flnb}

  def take_and_rest(list, trigger)
  def take_and_rest(list, %Regex{}=trigger), do: _take_and_rest_rgx(list, trigger, [])
  def take_and_rest(list, trigger) when is_binary(trigger), do: _take_and_rest_str(list, trigger, [])
  def take_and_rest(list, trigger) when is_function(trigger), do: _take_and_rest_fun(list, trigger, [])

  defp _replace_tabs(lines) do
    lines
    |> Enum.reverse
    |> Enum.join("\n")
    |> String.replace("→", "\t")
  end

  defp _take_and_rest_rgx(list, rgx, result)
  defp _take_and_rest_rgx([], _rgx, result), do:
    {:warn, "End of list without match", Enum.reverse(result)}
  defp _take_and_rest_rgx([{line, _}=element|rest], rgx, result) do
    if Regex.match?(rgx, line) do
      {Enum.reverse(result), rest}
    else
      _take_and_rest_rgx(rest, rgx, [element|result])
    end
  end

  defp _take_and_rest_str(list, str, result)
  defp _take_and_rest_str([], _str, result), do:
    {:warn, "End of list without match", Enum.reverse(result)}
  defp _take_and_rest_str([{line, _}=element|rest], str, result) do
    if line == str do
      {:ok, {Enum.reverse(result), rest}}
    else
      _take_and_rest_str(rest, str, [element|result])
    end
  end

  defp _take_and_rest_fun(list, fun, result)
  defp _take_and_rest_fun([], _fun, result), do:
    {:warn, "End of list without match", Enum.reverse(result)}
  defp _take_and_rest_fun([{line, _}=element|rest], fun, result) do
    if fun.(line) do
      {:ok, {Enum.reverse(result), rest}}
    else
      _take_and_rest_fun(rest, fun, [element|result])
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
