defmodule Servy.GenericFourOhFourServer do
  def start(callback_module, initial_count, name) do
    pid = spawn(__MODULE__, :listen, [initial_count, callback_module])
    Process.register(pid, name)
    pid
  end

  def call(pid, message) do
    send pid, {self(), message}

    receive do {:response, response} -> response end
  end

  def listen(count, callback_module) do
    receive do
      {sender, message} when is_pid(sender) ->
        {response, new_count} = callback_module.handle_call(message, count)
        send sender, {:response, response}
        listen(new_count, callback_module)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        listen(count, callback_module)
    end
  end

end

defmodule Servy.FourOhFourCounter do
  @name __MODULE__

  alias Servy.GenericFourOhFourServer
  # Client Functions

  def start(initial_count \\ %{}) do
    IO.puts "Starting the 404 server..."
    GenericFourOhFourServer.start(@name, initial_count, @name)
  end

  def bump_count(pathname) do
    GenericFourOhFourServer.call @name, {:bump_count, pathname}
  end

  def get_count(pathname) do
    GenericFourOhFourServer.call @name, {:get_count, pathname}
  end

  def get_counts, do: GenericFourOhFourServer.call @name, :get_counts

  # Server functions


  def handle_call({:bump_count, pathname}, count) do
    {:ok, new_count} = create_or_increment_count(count, pathname)
    {new_count, new_count}
  end

  def handle_call({:get_count, pathname}, count), do: {count[pathname], count}

  def handle_call(:get_counts, count), do: {count, count}

  defp create_or_increment_count(count, endpoint) do
    {:ok, Map.update(count, endpoint, 1, &(&1 + 1))}
  end
end
