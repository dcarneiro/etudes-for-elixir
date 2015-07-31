defmodule Stats do
  def minimum(list) do
    [head|tail] = list
    minimum(tail, head)
  end

  defp minimum([], result) do
    result
  end

  defp minimum([head|tail], result) when result < head do
    minimum(tail, result)
  end

  defp minimum([head|tail], _result) do
    minimum(tail, head)
  end

  def maximum(list) do
    [head|tail] = list
    maximum(tail, head)
  end

  defp maximum([], result) do
    result
  end

  defp maximum([head|tail], result) when result > head do
    maximum(tail, result)
  end

  defp maximum([head|tail], _result) do
    maximum(tail, head)
  end

  def range(list) do
    [minimum(list), maximum(list)]
  end

  @doc """
  Returns the mean of a list of numbers.
  """
  def mean(list) do
    sum = List.foldl(list, 0, fn (x, acc) -> x + acc end)
    sum / Enum.count(list)
  end

  @doc """
  Returns the standard deviation of the list
  """
  def stdv(list) do
    sum = List.foldl(list, 0, fn (x, acc) -> x + acc end)
    sum_of_squares = List.foldl(list, 0, fn (x, acc) -> x * x + acc end)
    n = Enum.count(list)
    :math.sqrt((n * sum_of_squares - sum * sum)/(n * (n - 1)))
  end
end
