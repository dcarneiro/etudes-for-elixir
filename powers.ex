defmodule Powers do
  import Kernel, except: [raise: 2, raise: 3]

  def raise(x, n) do
    cond do
      n == 0  -> 1
      n > 0   -> raise(x, n, 1)
      n < 0   -> 1.0 / raise(x, - n)
    end
  end

  def raise(x, n, accumulator) do
    case n do
      0 -> accumulator
      _ -> raise(x, n - 1, x * accumulator)
    end
  end

  def nth_root(x, n) do
    nth_root(x, n, x / 2.0)
  end

  defp nth_root(x, n, a) do
    IO.puts("Current guess is #{a}")
    f = raise(a, n) - x
    f_prime = n * raise(a, n - 1)
    next = a - f / f_prime
    change = abs(next - a)
    cond do
      change < 1.0e-8 -> next
      true            -> nth_root(x, n, next)
    end
  end
end
