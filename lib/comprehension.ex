defmodule Comprehend do
  @ranks ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
  @suits ["♣", "♦", "♥", "♠"]
  @deck for rank <- @ranks, suit <- @suits, do: { rank, suit }

  def shuffle_thirteen() do
    @deck
    |> Enum.shuffle
    |> Enum.take(13)
    |> IO.inspect
  end

  def deal_deck() do
    @deck
    |> Enum.shuffle
    |> Enum.chunk_every(13)
    |> IO.inspect
  end
end
