defmodule FactEngine.Parser do
  # string -> {:ok, [{statement, command, [args]}]}
  def parse(input) do
    result =
      input
      |> String.trim()
      |> String.replace("(", "")
      |> String.replace(")", "")
      |> String.replace(",", "")
      |> String.split("\n")
      |> Enum.map(&String.split/1)
      |> Enum.map(&convert/1)

    {:ok, result}
  end

  defp convert(["INPUT", statement | args]) do
    {:input, statement, create_set(args)}
  end

  defp convert(["QUERY", statement | args]) do
    {:query, statement, create_set(args)}
  end

  defp create_set(args) when is_list(args) do
    MapSet.new(args)
  end

  defp create_set(arg), do: MapSet.new([arg])
end
