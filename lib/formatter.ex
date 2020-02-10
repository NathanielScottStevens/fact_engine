defmodule FactEngine.Formatter do
  def format(output) do
    {:ok, Enum.flat_map(output, &format_line/1)}
  end

  defp format_line(line) when is_boolean(line) do
    ["---", to_string(line)]
  end

  defp format_line(line) when is_list(line) do
    ["---" | Enum.map(line, &format_map/1)]
  end

  defp format_map(map) when is_map(map) and map_size(map) == 1 do
    [{k, v}] = Map.to_list(map)
    "#{k}: #{v}"
  end
end
