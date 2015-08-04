defmodule Cards do
  def make_deck do
    for x <- cards_values, y <- suits, do: { x, y }
  end

  defp suits do
    ["Hearts", "Diamonds", "Clubs", "Spades"]
  end

  defp cards_values do
    ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
  end
end