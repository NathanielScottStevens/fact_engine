defmodule FactEngine.Evaluate do
  @type command() :: :input | :query
  @type statement() :: String.t()
  @type args() :: [String.t()]
  @type output() :: [String.t()]

  @type state() :: %{facts: %{statement() => args | [args]}, bound_args: %MapSet{}}
  # state = %{facts: %{"is_a_cat": ["lucy"], "are_friends": [["lucy", "mike"]]}, args: ["lucy", "mike"]}

  @spec eval([{command(), statement(), args()}]) :: {:ok, output()}
  def eval(input) do
    {state, output} =
      Enum.reduce_while(input, {%{facts: %{}, bound_args: MapSet.new()}, []}, &eval_command/2)

    {:ok, output}
  end

  # @spec eval_command({command(), statement(), args()}) :: {:cont | :halt, state(), output()}
  defp eval_command({:input, statement, args}, {state, output}) do
    %{facts: facts, bound_args: bound_args} = state

    updated_facts = update_facts(facts, statement, args)
    updated_bound_args = update_bound_args(bound_args, args)

    {:cont, {%{facts: updated_facts, bound_args: updated_bound_args}, output}}
  end

  defp eval_command({:query, statement, args}, {state, output}) do
    if statement_defined?(state, statement) do
      result = evaluate_statement(statement, args, state)
      {:cont, {state, [result | output]}}
    else
      {:halt, {state, ["error: #{statement} is undefined"]}}
    end
  end

  defp update_facts(facts, statement, [arg]) do
    Map.update(facts, statement, [arg], fn old -> [arg | old] end)
  end

  defp update_facts(facts, statement, args) do
    Map.update(facts, statement, [args], fn old -> old ++ args end)
  end

  defp update_bound_args(bound_args, args) do
    MapSet.union(bound_args, MapSet.new(args))
  end

  defp statement_defined?(%{facts: facts}, statement), do: Map.has_key?(facts, statement)

  defp evaluate_statement(statement, args, state) do
    %{facts: facts, bound_args: bound_args} = state

    # If all args are bound
    #   evaluate to boolean
    # If all args are unbound
    #   return full list of args
    # If both bound and unbound
    #   show valid matches

    cond do
      # MapSet.equal?
      Enum.all?(args, &MapSet.member?(bound_args, &1)) ->
        eval_bool(facts, statement, args)

      # MapSet.disjoint?
      Enum.all?(args, &(not MapSet.member?(bound_args, &1))) ->
        Enum.map(facts[statement], &%{Enum.at(args, 0) => &1})

        # MapSet.difference/intersection
    end
  end

  defp eval_bool(facts, statement, [arg]) do
    Enum.member?(facts[statement], arg) |> to_string()
  end

  defp eval_bool(facts, statement, args) do
    # TODO improve effeciency of Enum.reverse, maybe use MapSets
    Enum.any?(facts[statement], fn x -> x == args || x == Enum.reverse(args) end)
    |> to_string()
  end
end
