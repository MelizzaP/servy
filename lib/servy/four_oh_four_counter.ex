defmodule Servy.FourOhFourCounter do
  @name __MODULE__

  use GenServer

  # Client Functions

  def start(initial_count \\ %{}) do
    IO.puts "Starting the 404 server..."
    GenServer.start(__MODULE__, initial_count, name: @name)
  end

  def bump_count(pathname), do: GenServer.call @name, {:bump_count, pathname}

  def get_count(pathname), do: GenServer.call @name, {:get_count, pathname}

  def get_counts, do: GenServer.call @name, :get_counts

  # Server functions

  def handle_call({:bump_count, pathname}, _from, count) do
    {:ok, new_count} = create_or_increment_count(count, pathname)
    {:reply, new_count, new_count}
  end

  def handle_call({:get_count, pathname}, _from, count) do
    {:reply, count[pathname], count}
  end

  def handle_call(:get_counts, _from, count), do: {:reply, count, count}

  defp create_or_increment_count(count, endpoint) do
    {:ok, Map.update(count, endpoint, 1, &(&1 + 1))}
  end
end
