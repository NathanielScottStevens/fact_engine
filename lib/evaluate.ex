defmodule FactEngine.Evaluate do
  def eval(input) do
    {_, _, output} = Enum.reduce(input, {%{}, MapSet.new(), []}, &eval_command/2)
    query_output = Enum.reverse(output)

    {:ok, query_output}
  end

  defp eval_command({:input, statement, args}, {facts, bound_args, output}) do
    updated_facts = update_facts(facts, statement, args)
    updated_bound_args = update_bound_args(bound_args, args)

    {updated_facts, updated_bound_args, output}
  end

  defp eval_command({:query, statement, args}, {facts, bound_args, output}) do
    statement_facts = facts[statement]

    result =
      if statement_facts do
        variable_result =
          Enum.map(statement_facts, &Enum.zip(args, &1))
          |> Enum.map(&eval_unbound(&1, statement_facts, args, bound_args))
          |> Enum.map(&pattern_match/1)
      else
        [[false]]
      end

    {facts, bound_args, [result | output]}
  end

  defp pattern_match(results) do
    cond do
      Enum.all?(results, &(&1 == true)) -> [true]
      Enum.any?(results, &(&1 == false)) -> [false]
      same_values_not_equal?(results) -> [false]
      true -> results
    end
  end

  defp same_values_not_equal?(results) do
    results
    |> Enum.filter(&is_tuple(&1))
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.any?(fn {k, v} -> length(v) > 1 end)
  end

  defp eval_unbound(args_to_values, statement_facts, args, bound_args) do
    Enum.map(args_to_values, fn
      {x, x} ->
        true

      {arg, value} ->
        if not MapSet.member?(bound_args, arg) do
          {arg, value}
        else
          false
        end
    end)
  end

  defp update_facts(facts, statement, args) do
    Map.update(facts, statement, [args], fn old -> [args | old] end)
  end

  defp update_bound_args(bound_args, args) do
    MapSet.union(bound_args, MapSet.new(args))
  end
end
