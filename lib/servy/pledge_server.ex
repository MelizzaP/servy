defmodule Servy.GenericServer do
  def start(callback_module, initial_state \\ [], name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def call(pid, message) do
    send pid, {:call, self(), message}

    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end

  def info(pid, message) do
    send pid, message
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state, callback_module)
      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)
      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        new_state = callback_module.handle_info(unexpected, state)
        listen_loop(new_state, callback_module)
    end
  end
end

defmodule Servy.PledgeServer do
  @name __MODULE__

  alias Servy.GenericServer

  # Client interface functions
  def start do
    IO.puts "Starting the pledge server..."
    GenericServer.start(__MODULE__, [], @name)
  end

  def create_pledge(name, amount) do
    GenericServer.call @name, {:create_pledge, name, amount}
 end

  def recent_pledges, do: GenericServer.call @name, :recent_pledges

  def total_pledged, do: GenericServer.call @name, :total_pledged

  def clear, do: GenericServer.cast @name, :clear

  # Server callbacks

  def handle_cast(:clear, _state), do: []

  def handle_call(:recent_pledges, state), do: {state, state}

  def handle_call(:total_pledged, state) do
    {Enum.map(state, &elem(&1, 1)) |> Enum.sum(), state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_pledges]

    {id, new_state}
  end

  def handle_info(huh, state) do
    IO.puts "Idk wtf this is... #{huh}"
    state
  end

  defp send_pledge_to_service(_name, _amount) do
    # code here to send pledge to external service

    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

alias Servy.PledgeServer

pid = PledgeServer.start()

IO.inspect(PledgeServer.create_pledge("larry", 10))
IO.inspect(PledgeServer.create_pledge("curly", 20))
IO.inspect(PledgeServer.create_pledge("moe", 30))
IO.inspect(PledgeServer.create_pledge("diasy", 40))

PledgeServer.clear()

IO.inspect(PledgeServer.create_pledge("grace", 50))

IO.inspect(PledgeServer.recent_pledges())
IO.inspect(PledgeServer.total_pledged())
IO.inspect(Process.info(pid, :messages))
