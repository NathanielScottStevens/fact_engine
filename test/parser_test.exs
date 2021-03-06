defmodule ParserTest do
  use ExUnit.Case
  alias FactEngine.Parser

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

  test "trims whitespace" do
    expected = {:ok, [{:input, "is_a_cat", ["lucy"]}, {:query, "is_a_cat", ["lucy"]}]}

    actual = Parser.parse(" \nINPUT is_a_cat (lucy)\nQUERY is_a_cat (lucy)  \n\n")
    assert expected == actual
  end
end
