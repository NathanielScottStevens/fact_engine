defmodule ParserTest do
  use ExUnit.Case
  alias FactEngine.Parser

  # INPUT is_a_cat (lucy)
  # QUERY is_a_cat (lucy)
  # INPUT are_friends (alex, sam)
  # QUERY are_friends (X, sam)
  # QUERY is_a_cat (X)
  # QUERY are_friends (X, Y)
  # INPUT are_friends (sam, sam)
  # QUERY are_friends (Y, Y)

  # TODO: Add error cases
  test "parses input" do
    expected = {:ok, [{:input, "is_a_cat", ["lucy"]}]}
    actual = Parser.parse("INPUT is_a_cat (lucy)")
    assert expected == actual
  end

  test "parses query" do
    expected = {:ok, [{:query, "is_a_cat", ["lucy"]}]}
    actual = Parser.parse("QUERY is_a_cat (lucy)")
    assert expected == actual
  end

  test "parses multiple args" do
    expected = {:ok, [{:query, "are_friends", ["alex", "sam"]}]}
    actual = Parser.parse("QUERY are_friends (alex, sam)")
    assert expected == actual
  end

  test "parses multiple lines" do
    expected = {:ok, [{:input, "is_a_cat", ["lucy"]}, {:query, "is_a_cat", ["lucy"]}]}
    actual = Parser.parse("INPUT is_a_cat (lucy)\nQUERY is_a_cat (lucy)")
    assert expected == actual
  end
end
