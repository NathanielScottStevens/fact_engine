defmodule FormatterTest do
  use ExUnit.Case
  alias FactEngine.Formatter

  test "formats booleans" do
    assert {:ok, ["---", "true"]} == Formatter.format([true])
  end

  test "formats list of maps" do
    input = [[%{"X" => "ben"}, %{"X" => "lucy"}]]
    expected = ["---", "X: ben", "X: lucy"]

    {:ok, actual} = Formatter.format(input)
    assert expected == actual
  end
end
