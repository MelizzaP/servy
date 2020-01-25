defmodule Timer do
  def remind(string, seconds) do
    spawn(fn ->
      :timer.sleep(seconds * 1000)
      IO.puts(string)
    end)
  end
end

Timer.remind("Stand Up", 5)
Timer.remind("Sit Down", 10)
Timer.remind("Fight, Fight, Fight", 15)
