defmodule Recurse do
  def sum([head | tail], total) do
    sum(tail, total + head)
  end

  def sum([], total), do: total

  def triple(list) do
    triple(list, [])
  end

  defp triple([head | tail], list) do
    triple(tail, [head * 3 | list])
  end

  defp triple([], list), do: list |> Enum.reverse
end

IO.puts Recurse.sum([1, 2, 3, 4, 5], 0)
IO.inspect Recurse.triple([1, 2, 3, 4, 5])
