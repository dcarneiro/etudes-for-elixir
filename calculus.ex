defmodule Calculus do
  def derivative(func, x) do
    delta = 1.0e-10
    (func.(x + delta) - func.(x)) / delta
  end

  def older_males(people) do
    over_40? = fn(n) -> n > 40 end
    for {name, "M", age} <- people, over_40?.(age), do: name
  end

  def older_or_males(people) do
    over_40_or_name? = fn(age, gender) -> age > 40 or gender == "M" end
    for {name, gender, age} <- people, over_40_or_name?.(age, gender), do: name
  end
end