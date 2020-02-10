defmodule EvaluateTest do
  use ExUnit.Case
  alias FactEngine.Evaluate

  test "returns single argument statement as true when true" do
    input = [
      {:input, "is_a_cat", MapSet.new(["lucy"])},
      {:query, "is_a_cat", MapSet.new(["lucy"])}
    ]

    assert {:ok, [true]} == Evaluate.eval(input)
  end

  test "returns single argument statement as false when false" do
    input = [
      {:input, "is_a_cat", MapSet.new(["lucy"])},
      {:input, "is_a_dog", MapSet.new(["ben"])},
      {:query, "is_a_cat", MapSet.new(["ben"])}
    ]

    assert {:ok, [false]} == Evaluate.eval(input)
  end

  test "returns error when statement is undefined" do
    input = [{:query, "is_a_cat", MapSet.new(["lucy"])}]
    # TODO give better error message
    assert {:ok, ["error: is_a_cat is undefined"]} == Evaluate.eval(input)
  end

  test "can handle multiple arg statements" do
    input = [
      {:input, "are_friends", MapSet.new(["alex", "sam"])},
      {:query, "are_friends", MapSet.new(["alex", "sam"])}
    ]

    assert {:ok, [true]} == Evaluate.eval(input)
  end

  test "returns all matching single arguments" do
    input = [
      {:input, "is_a_cat", MapSet.new(["lucy"])},
      {:input, "is_a_cat", MapSet.new(["ben"])},
      {:query, "is_a_cat", MapSet.new(["X"])}
    ]

    expected = {:ok, [[%{"X" => MapSet.new(["ben"])}, %{"X" => MapSet.new(["lucy"])}]]}

    assert expected == Evaluate.eval(input)
  end

  test "can handle single unbounded variable" do
    input = [
      {:input, "are_friends", MapSet.new(["alex", "sam"])},
      {:input, "are_friends", MapSet.new(["alex", "ben"])},
      {:query, "are_friends", MapSet.new(["alex", "X"])}
    ]

    # This is a poorly written assertion, it demands the list to be in a specific order
    assert {:ok, [[%{"X" => "ben"}, %{"X" => "sam"}]]} == Evaluate.eval(input)
  end
end
