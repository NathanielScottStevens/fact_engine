defmodule FactEngine.Evaluate do
  alias FactEngine.Parser
  @type arg() :: String.t()
  @type value() :: String.t()
  @type program_output() :: [query_results()]
  @type match_results() :: [{arg(), value}]
  @type query_results() :: [true | false | match_results()]
  @type facts() :: %{required(Parser.statement()) => [Parser.args()]}
  @type bound_args() :: MapSet.t(Parser.args())
  @type accumulator() :: {
          facts(),
          bound_args(),
          program_output()
        }

  @spec eval([{Parser.command(), Parser.statement(), Parser.args()}]) :: {:ok, program_output()}
  def eval(input) do
    {_, _, output} = Enum.reduce(input, {%{}, MapSet.new(), []}, &eval_command/2)
    query_output = Enum.reverse(output)

    {:ok, query_output}
  end

  @spec eval_command({Parser.command(), Parser.statement(), Parser.args()}, accumulator()) ::
          accumulator()
  defp eval_command({:input, statement, args}, {facts, bound_args, output}) do
    updated_facts = update_facts(facts, statement, args)
    updated_bound_args = update_bound_args(bound_args, args)

    {updated_facts, updated_bound_args, output}
  end

  defp eval_command({:query, statement, args}, {facts, bound_args, output}) do
    statement_facts = facts[statement]

    result =
      if statement_facts do
        statement_facts
        |> Enum.map(&Enum.zip(args, &1))
        |> Enum.map(&eval_unbound(&1, bound_args))
        |> Enum.map(&pattern_match/1)
        |> clean_result()
      else
        false
      end

    {facts, bound_args, [result | output]}
  end

  @spec update_facts(facts(), Parser.statement(), Parser.args()) :: facts()
  defp update_facts(facts, statement, args) do
    Map.update(facts, statement, [args], fn old -> [args | old] end)
  end

  @spec update_bound_args(bound_args(), Parser.args()) :: bound_args()
  defp update_bound_args(bound_args, args) do
    MapSet.union(bound_args, MapSet.new(args))
  end

  @spec eval_unbound([{Parser.args(), Parser.args()}], bound_args) ::
          query_results()
  defp eval_unbound(args_to_values, bound_args) do
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

  @spec pattern_match([query_results()]) :: true | false | [query_results()]
  defp pattern_match(results) do
    cond do
      Enum.all?(results, &(&1 == true)) -> true
      Enum.any?(results, &(&1 == false)) -> false
      same_values_not_equal?(results) -> false
      true -> results
    end
  end

  # TODO: write this as a reduce
  @spec clean_result([query_results()]) :: query_results()
  defp clean_result(results) do
    Enum.reduce(results, {true, []}, fn result, {truth, variables} ->
      case result do
        false -> {false, variables}
        true -> {truth, variables}
        var -> {truth, [var | variables]}
      end
    end)

    # cond do
    #   Enum.all?(results, &(&1 == true)) -> true
    #   Enum.any?(results, &(&1 == false)) -> false
    #   true -> Enum.reject(results, &is_boolean/1)
    # end
  end

  @spec same_values_not_equal?([query_results()]) :: true | false
  defp same_values_not_equal?(results) do
    results
    |> Enum.filter(&is_tuple(&1))
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.any?(fn {_, v} -> length(v) > 1 end)
  end
end
