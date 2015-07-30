defmodule NonFP do
  def generate_pockets(list, probability) do
    :random.seed(:erlang.now())
    generate_pockets(list, probability, [])
  end

  defp generate_pockets([], _, result) do
    Enum.reverse(result)
  end

  defp generate_pockets([head|tail], probability, result) do
    case head do
      ?T -> generate_pockets(tail, :random.uniform(), [generate_tooth(probability)|result])
      _ -> generate_pockets(tail, :random.uniform(), [[0]|result])
    end
  end

  defp generate_tooth(probability) do
    cond do
      probability < 0.8 -> generate_tooth(2, 6, [])
      true -> generate_tooth(3, 6, [])
    end
  end

  defp generate_tooth(_base_depth, 0, list) do
    list
  end

  defp generate_tooth(base_depth, size, list) do
    delta = :random.uniform(3) - 2
    generate_tooth(base_depth, size - 1, [base_depth + delta|list])
  end

  def test_pockets() do
    tlist = 'FTTTTTTTTTTTTTTFTTTTTTTTTTTTTTTT'
    big_list = generate_pockets(tlist, 0.75)
    print_pockets(big_list)
  end

  def print_pockets([]), do: IO.puts("Finished.")

  def print_pockets([head | tail]) do
    IO.puts(inspect(head))
    print_pockets(tail)
  end
end