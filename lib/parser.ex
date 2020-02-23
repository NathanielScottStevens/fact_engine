defmodule FactEngine.Parser do
  @type command() :: :input | :query
  @type statement() :: String.t()
  @type args() :: [String.t()]

  @spec parse(String.t()) :: {:ok, [{command(), statement(), args()}]}
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
    {:input, statement, args}
  end

  defp convert(["QUERY", statement | args]) do
    {:query, statement, args}
  end
end
