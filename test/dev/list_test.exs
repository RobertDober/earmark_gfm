defmodule Test.Dev.ListTest do
  @moduledoc false
  use ExUnit.Case

  import Dev.MkSpecs.List, only: [take_and_rest: 2]

  describe "empty will return errors" do
    test "all empty" do
      assert take_and_rest([], "not found") ==
        {:warn, "End of list without match", []}
    end
    test "no match found" do
      list = [{1, 1}, {2, 2}]
      assert take_and_rest(list, "not found") ==
        {:warn, "End of list without match", list}
    end
  end

  describe "string based partition" do
    test "first part empty" do
      second = [{1, 1}, {2, 2}]
      list = [{".", 0} | second] 
      assert take_and_rest(list, ".") ==
        {:ok, {[], second}}
    end
  end

end
# SPDX-License-Identifier: Apache-2.0
