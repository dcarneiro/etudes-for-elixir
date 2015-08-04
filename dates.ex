defmodule Dates do
  def date_parts(input) do
    String.split(input, "-", trim: true, parts: 3) |> Enum.map(fn x -> :erlang.binary_to_integer(x) end)
  end

  def julian(date) do
    [y, m, d] = date_parts(date)
    days_per_month = [31,28,31,30,31,30,31,31,30,31,30,31]
    result = month_total(m, days_per_month, 0) + d
    handle_leap_year(result, y, m)
  end

  def other_julian(date) do
    [y, m, d] = date_parts(date)
    {relevant_months, _ } = Enum.split(days_per_month, m - 1)
    result = List.foldl(relevant_months, 0, fn(x, acc) -> x + acc end) + d
    handle_leap_year(result, y, m)
  end

  defp days_per_month do
    [31,28,31,30,31,30,31,31,30,31,30,31]
  end

  defp handle_leap_year(result, y, m) do
    cond do
      is_leap_year(y) and m > 2 -> result + 1
      true -> result
    end
  end

  defp month_total(1, _days_per_month, total) do
    total
  end

  defp month_total(m, [this_month|other_months], total) do
    month_total(m - 1, other_months, total + this_month)
  end

  defp is_leap_year(year) do
    (rem(year,4) == 0 and rem(year,100) != 0) or (rem(year, 400) == 0)
  end

end
