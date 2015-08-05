defmodule Player do
  @doc """
  The player starting deck
  """
  def start(deck) do
    play(deck)
  end

  def play(hand) do
    receive do
      { :give, n, dealer } ->
        { to_send, to_keep } = Enum.split(hand, n)
        send(dealer, { :take, to_send, self() })
        play(to_keep)
      { :pick_up, cards, dealer } ->
        new_hand = hand ++ cards
        IO.puts("Player #{inspect(self)} has #{inspect(new_hand)}")
        send(dealer, { :got_cards, self() })
        play(new_hand)
      :game_over ->
        IO.puts("Player #{inspect(self)} leaves.")
    end
  end
end
