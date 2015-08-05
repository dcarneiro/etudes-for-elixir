defmodule Dealer do
  @moduledoc """
  This will simulate the dealer in the war game
  """

  @doc """
  Starts the war game
  """
  def start do
    deck = Deck.build |> shuffle
    {hand1, hand2} = Enum.split(deck, trunc(Enum.count(deck) / 2))
    p1 = spawn(Player, :start, [hand1])
    p2 = spawn(Player, :start, [hand2])
    play([p1, p2], :pre_battle, [], [], 0, [])
  end

  @doc """
  this will ask cards for each player
  """
  def play(players, :pre_battle, cards1, cards2, n_received, pile) do
    IO.puts ""
    case pile do
      [] ->
        IO.puts("Requesting 1 card from each player")
        request_cards(players, 1)
      _ ->
        IO.puts("Requesting 3 cards from each player")
        request_cards(players, 3)
    end
    play(players, :await_battle, cards1, cards2, n_received, pile)
  end

  @doc """
  When both players have given you their card(s), you need to check them.
  """
  def play(players, :await_battle, cards1, cards2, n_received, pile) when n_received == 2 do
    play(players, :check_cards, cards1, cards2, 0, pile)
  end

  @doc """
  waiting for players to send you cards
  """
  def play([p1, p2], :await_battle, cards1, cards2, n_received, pile) do
    receive do
      { :take, new_cards, from } ->
        IO.puts("Got #{inspect(new_cards)} from #{inspect(from)}")
        cond do
          from == p1 -> play([p1, p2], :await_battle, new_cards, cards2, n_received + 1, pile)
          from == p2 -> play([p1, p2], :await_battle, cards1, new_cards, n_received + 1, pile)
        end
    end
  end

  def play(players, :check_cards, cards1, cards2, _, pile) do
    cond do
      cards1 == [] and cards2 == [] ->
        IO.puts("Draw")
      cards1 == [] ->
        IO.puts("Player 2 wins")
      cards2 == [] ->
        IO.puts("Player 1 wins")
      true ->
        new_pile = evaluate(players, cards1, cards2, pile)
        play(players, :pre_battle, [], [], 0, new_pile)
    end
  end

  def evaluate([p1, p2], cards1, cards2, pile) do
    v1 = card_value(hd(cards1))
    v2 = card_value(hd(cards2))
    IO.puts("Value of card 1 is #{v1}; value of card 2 is #{v2}")
    new_pile = Enum.concat([pile, cards1, cards2])
    IO.puts("Card pile is now #{inspect(new_pile)}")
    cond do
      v1 == v2 ->
        IO.puts("Equal values; going to war.")
        new_pile
      v1 > v2 ->
        IO.puts("Telling player 1 to pick up the cards because #{v1} > #{v2}")
        send(p1, {:pick_up, new_pile, self()})
        wait_for_pickup()
        []
      true ->
        IO.puts("Telling player 2 to pick up the cards because #{v1} < #{v2}")
        send(p2, {:pick_up, new_pile, self()})
        wait_for_pickup()
        []
    end
  end

  def wait_for_pickup() do
    receive do
      {:got_cards, player} ->
        IO.puts("Player #{inspect(player)} picked up cards.")
        player
    end
  end

  def request_cards([p1, p2], n) do
    send(p1, {:give, n, self()})
    send(p2, {:give, n, self()})
  end

  @doc """
  Shuffle the list
  """
  def shuffle(list) do
    :random.seed(:erlang.now())
    shuffle(list, [])
  end

  defp shuffle([], acc) do
    acc
  end

  defp shuffle(list, acc) do
    {leading, [h | t]} = Enum.split(list, :random.uniform(Enum.count(list)) - 1)
    shuffle(leading ++ t, [h | acc])
  end

  defp card_value({value, _suit}) do
    case value do
      "A" -> 14
      "K" -> 13
      "Q" -> 12
      "J" -> 11
      _ -> value
    end
  end
end
