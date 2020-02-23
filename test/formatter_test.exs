defmodule FormatterTest do
  use ExUnit.Case
  alias FactEngine.Formatter

  test "formats booleans" do
    assert {:ok, ["---", "true"]} == Formatter.format([true])
  end

  test "formats list of maps" do
    input = [[[{"X", "ben"}], [{"X", "lucy"}]]]
    expected = ["---", "X: ben", "X: lucy"]

    {:ok, actual} = Formatter.format(input)
    assert expected == actual
  end

  test "formats multiple variables" do
    input = [[[{"X", "5"}, {"Y", "6"}], [{"X", "7"}, {"Y", "8"}]]]
    expected = ["---", "X: 5, Y: 6", "X: 7, Y: 8"]

    {:ok, actual} = Formatter.format(input)
    assert expected == actual
  end
end
