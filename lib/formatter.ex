defmodule FactEngine.Formatter do
  @spec format(FactEngine.Evaluate.program_output()) :: {:ok, [String.t()]}
  def format(output) do
    {:ok, Enum.flat_map(output, &format_query_result/1)}
  end

  defp format_query_result(query_result) when is_boolean(query_result) do
    ["---", to_string(query_result)]
  end

  defp format_query_result(query_result) when is_list(query_result) do
    ["---" | Enum.map(query_result, &format_match/1)]
  end

  defp format_match(match) do
    match
    |> Enum.map(fn {var, val} -> "#{var}: #{val}" end)
    |> Enum.join(", ")
  end
end
