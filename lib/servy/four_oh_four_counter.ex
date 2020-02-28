defmodule Servy.FourOhFourCounter do
  @name __MODULE__

  # Client Functions

  def start(initial_count \\ %{}) do
    pid = spawn(__MODULE__, :listen, [initial_count])
    Process.register(pid, @name)
    pid
  end

  def bump_count(pathname) do
    send(@name, {self(), :bump_count, pathname})

    receive do
      {:response, count} -> count
    end
  end

  def get_count(pathname) do
    send(@name, {self(), :get_count, pathname})

    receive do
      {:response, count} -> count
    end
  end

  def get_counts do
    send(@name, {self(), :get_counts})

    receive do
      {:response, counts} -> counts
    end
  end

  # Server functions

  def listen(count) do
    receive do
      {sender, :bump_count, pathname} ->
        {:ok, new_count} = create_or_increment_count(count, pathname)
        send(sender, {:response, count})
        listen(new_count)

      {sender, :get_count, pathname} ->
        send(sender, {:response, count[pathname]})
        listen(count)

      {sender, :get_counts} ->
        send(sender, {:response, count})
        listen(count)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        listen(count)
    end
  end

  defp create_or_increment_count(count, endpoint) do
    {:ok, Map.update(count, endpoint, 1, &(&1 + 1))}
  end
end
