defmodule FactEngine.Evaluate do
  def eval(input) do
    {state, output} = Enum.reduce_while(input, {%{}, []}, &eval_command/2)
    {:ok, output}
  end

  defp eval_command({:input, statement, [arg]}, {state, output}) do
    {:cont, {Map.update(state, statement, [arg], fn old -> [arg | old] end), output}}
  end

  defp eval_command({:query, statement, [arg]}, {state, output}) do
    if Map.has_key?(state, statement) do
      result = Enum.member?(state[statement], arg) |> to_string()
      {:cont, {state, [result | output]}}
    else
      {:halt, {state, ["error: #{statement} is undefined"]}}
    end
  end
end
