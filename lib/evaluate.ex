defmodule FactEngine.Evaluate do
  @type command() :: :input | :query
  @type statement() :: String.t()
  @type args() :: [String.t()]
  @type output() :: [String.t()]

  @type state() :: %{statement() => args | [args]}
  # state = %{"is_a_cat": ["lucy"], "are_friends": [["lucy", "mike"]]}

  @spec eval([{command(), statement(), args()}]) :: {:ok, output()}
  def eval(input) do
    {state, output} = Enum.reduce_while(input, {%{}, []}, &eval_command/2)
    {:ok, output}
  end

  # @spec eval_command({command(), statement(), args()}) :: {:cont | :halt, state(), output()}
  defp eval_command({:input, statement, [arg]}, {state, output}) do
    {:cont, {Map.update(state, statement, [arg], fn old -> [arg | old] end), output}}
  end

  defp eval_command({:input, statement, args}, {state, output}) do
    {:cont, {Map.update(state, statement, [args], fn old -> old ++ args end), output}}
  end

  defp eval_command({:query, statement, [arg]}, {state, output}) do
    if Map.has_key?(state, statement) do
      result = Enum.member?(state[statement], arg) |> to_string()
      {:cont, {state, [result | output]}}
    else
      {:halt, {state, ["error: #{statement} is undefined"]}}
    end
  end

  defp eval_command({:query, statement, args}, {state, output}) do
    if Map.has_key?(state, statement) do
      result =
        Enum.any?(state[statement], fn x -> x == args || x == Enum.reverse(args) end)
        |> to_string()

      {:cont, {state, [result | output]}}
    else
      {:halt, {state, ["error: #{statement} is undefined"]}}
    end
  end
end
