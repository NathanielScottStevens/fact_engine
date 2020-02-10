defmodule FactEngine do
  alias FactEngine.Parser
  alias FactEngine.Evaluate
  alias FactEngine.Formatter

  def main(args) when length(args) == 1 do
    [file] = args

    file
    |> File.read()
    |> apply_to_ok(&Parser.parse/1)
    |> apply_to_ok(&Evaluate.eval/1)
    |> apply_to_ok(&Formatter.format/1)
    |> apply_to_ok(&print/1)
  end

  def main(_) do
    IO.puts("Incorrect number of args. Takes [file_path].")
  end

  defp apply_to_ok({:ok, value}, func), do: func.(value)
  defp apply_to_ok(error), do: error

  defp print(results) do
    Enum.each(results, &IO.puts/1)
  end
end
