defmodule EvaluateTest do
  use ExUnit.Case
  alias FactEngine.Evaluate

  test "returns single argument statement as true when true" do
    input = [
      {:input, "is_a_cat", ["lucy"]},
      {:query, "is_a_cat", ["lucy"]}
    ]

    assert {:ok, [[true]]} == Evaluate.eval(input)
  end

  test "returns single argument statement as false when false" do
    input = [
      {:input, "is_a_cat", ["lucy"]},
      {:input, "is_a_dog", ["ben"]},
      {:query, "is_a_cat", ["ben"]}
    ]

    assert {:ok, [[false]]} == Evaluate.eval(input)
  end

  test "returns multiple queries" do
    input = [
      {:input, "is_a_cat", ["lucy"]},
      {:input, "is_a_dog", ["ben"]},
      {:query, "is_a_cat", ["ben"]},
      {:query, "is_a_cat", ["lucy"]}
    ]

    assert {:ok, [[false], [true]]} == Evaluate.eval(input)
  end

  test "returns false when statement is undefined" do
    input = [{:query, "is_a_cat", ["lucy"]}]
    assert {:ok, [[false]]} == Evaluate.eval(input)
  end

  test "can handle multiple arg statements" do
    input = [
      {:input, "are_friends", ["alex", "sam"]},
      {:query, "are_friends", ["alex", "sam"]}
    ]

    assert {:ok, [[true]]} == Evaluate.eval(input)
  end

  test "returns all matching single arguments" do
    input = [
      {:input, "is_a_cat", ["lucy"]},
      {:input, "is_a_cat", ["ben"]},
      {:query, "is_a_cat", ["X"]}
    ]

    expected = {:ok, [[[{"X", "ben"}], [{"X", "lucy"}]]]}

    assert expected == Evaluate.eval(input)
  end

  test "can handle single unbounded variable" do
    input = [
      {:input, "are_friends", ["alex", "sam"]},
      {:input, "are_friends", ["alex", "ben"]},
      {:query, "are_friends", ["alex", "X"]}
    ]

    expected = {:ok, [[[true, {"X", "ben"}], [true, {"X", "sam"}]]]}
    assert expected == Evaluate.eval(input)
  end

  test "works with triplets" do
    input = [
      {:input, "make_a_triple", ["3", "4", "5"]},
      {:input, "make_a_triple", ["5", "12", "13"]},
      {:query, "make_a_triple", ["X", "4", "Y"]},
      {:query, "make_a_triple", ["X", "X", "Y"]}
    ]

    expected = {:ok, [[[{"X", "3"}, {"Y", "5"}]], [false]]}
    assert expected == Evaluate.eval(input)
  end
end
