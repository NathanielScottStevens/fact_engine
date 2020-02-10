defmodule FactEngine.Evaluate do
  @type command() :: :input | :query
  @type statement() :: String.t()
  @type args() :: %MapSet{}
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

  defp update_facts(facts, statement, args) do
    Map.update(facts, statement, MapSet.new([args]), fn old -> MapSet.put(old, args) end)
  end

  defp update_bound_args(bound_args, args) do
    MapSet.union(bound_args, args)
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
    #
    statement_facts = facts[statement]
    # IO.inspect(bound_args, label: "lib/evaluate.ex:58")
    # IO.inspect(args, label: "lib/evaluate.ex:59")

    cond do
      all_args_bound?(args, bound_args) ->
        eval_predicate(statement_facts, args)

      only_one_of_one_args_unbound?(args, bound_args) ->
        eval_single_unbound_arg(statement_facts, Enum.at(args, 0))

      one_of_two_args_unbound?(args, bound_args) ->
        eval_one_of_two_unbound_args(statement_facts, args, bound_args)

      true ->
        nil
        # MapSet.difference/intersection
    end
  end

  defp all_args_bound?(args, bound_args), do: MapSet.subset?(args, bound_args)

  defp only_one_of_one_args_unbound?(args, bound_args), do: MapSet.disjoint?(bound_args, args)

  defp one_of_two_args_unbound?(args, bound_args) do
    num_of_unbound_args = MapSet.difference(args, bound_args) |> MapSet.size()
    num_of_unbound_args == 1
  end

  defp eval_predicate(statement_facts, args) do
    MapSet.member?(statement_facts, args)
  end

  defp eval_single_unbound_arg(statement_facts, arg) do
    Enum.map(statement_facts, &%{arg => &1})
  end

  defp eval_one_of_two_unbound_args(statement_facts, args, bound_args) do
    statement_facts
    |> MapSet.to_list()
    |> Enum.reject(&MapSet.disjoint?(&1, args))
    |> Enum.map(fn fact ->
      [variable] = Enum.reject(args, &MapSet.member?(bound_args, &1))

      [value] = MapSet.difference(fact, args) |> MapSet.to_list()

      %{variable => value}
    end)
  end
end
