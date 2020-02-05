defmodule FactEngine.RunLoop do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    send(self(), :run)
    {:ok, args}
  end

  def handle_info(:run, state) do
    IO.gets(">") |> IO.puts()

    send(self(), :run)
    {:noreply, state}
  end
end

