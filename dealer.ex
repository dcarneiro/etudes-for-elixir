defmodule Dealer do
  @moduledoc """
  Funcion for shuffling a list
  """

  def shuffle(list) do
    :random.seed(:erlang.now())
    shuffle(list, [])
  end

  def shuffle([], acc) do
    acc
  end

  @doc """
  receives one list of the items to process, and a acc with the processed items
  it randomly splits the list into leading, item, tail
  add the item into the processed items and calls the same method recursivly
  """
  def shuffle(list, acc) do
    {leading, [h | t]} = Enum.split(list, :random.uniform(Enum.count(list)) - 1)
    shuffle(leading ++ t, [h | acc])
  end
end