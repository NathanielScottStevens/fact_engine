defmodule FactEngine.Parser do
  # string -> {:ok, [{statement, command, [args]}]}
  def parse(input) do
    result =
      input
      |> String.replace("(", " ")
      |> String.replace(")", " ")
      |> String.split("\n")
      |> Enum.map(&String.split/1)
      |> Enum.map(&convert/1)

    {:ok, result}
  end

  def convert(["INPUT", statement | args]) do
    {:input, statement, args}
  end

  def convert(["QUERY", statement | args]) do
    {:query, statement, args}
  end
end
