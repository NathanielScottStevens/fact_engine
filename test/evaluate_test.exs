defmodule EvaluateTest do
  use ExUnit.Case
  alias FactEngine.Evaluate

  test "returns single argument statement as true when true" do
    input = [{:input, "is_a_cat", ["lucy"]}, {:query, "is_a_cat", ["lucy"]}]
    assert {:ok, ["true"]} == Evaluate.eval(input)
  end

  test "returns single argument statement as false when false" do
    input = [{:input, "is_a_cat", ["lucy"]}, {:query, "is_a_cat", ["ben"]}]
    assert {:ok, ["false"]} == Evaluate.eval(input)
  end

  test "returns error when statement is undefined" do
    input = [{:query, "is_a_cat", ["lucy"]}]
    # TODO give better error message
    assert {:ok, ["error: is_a_cat is undefined"]} == Evaluate.eval(input)
  end

  test "can handle multiple arg statements" do
    input = [
      {:input, "are_friends", ["alex", "sam"]},
      {:query, "are_friends", ["alex", "sam"]}
    ]

    assert {:ok, ["true"]} == Evaluate.eval(input)
  end
end
