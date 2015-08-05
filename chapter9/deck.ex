defmodule Deck do
  @moduledoc """
  Funcions to simulate a deck of cards
  """

  @doc """
  build a list with the defined suits and values
  """
  @spec build() :: list(tuple)
  def build do
    for x <- values, y <- suits, do: { x, y }
  end

  defp suits do
    ["Hearts", "Diamonds", "Clubs", "Spades"]
    # ["Hearts", "Diamonds"]
  end

  defp values do
    # ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"]
    ["A", 2, 3, 4, 5, "J", "Q", "K"]
  end
end