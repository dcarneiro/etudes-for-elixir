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
end
