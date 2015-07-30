defmodule AskArea do
  def area do
    input = IO.gets("R)ectangle, T)riangle, or E)llipse: ")
    shape = char_to_shape(String.first(input))
    {d1, d2} = case shape do
      :rectangle -> get_dimensions("width", "height")
      :triangle -> get_dimensions("base ", "height" )
      :ellipse -> get_dimensions("major radius", "minor radius")
      :unknown -> {String.first(input), 0}
    end
    calculate(shape, d1, d2)
  end

  def char_to_shape(input) do
    letter = String.first(input) |> String.upcase
    case letter  do
      "R"  -> :rectangle
      "T"  -> :triangle
      "E"  -> :ellipse
      _ -> :unknown
    end
  end

  def get_number(prompt) do
    input = IO.gets("Enter #{prompt} > ")
    input_str = String.strip(input)
    cond do
      Regex.match?(~r/^[+-]?\d+$/, input_str) ->
        :erlang.binary_to_integer(String.strip(input_str))
      Regex.match?(~r/^[+-]?\d+\.\d+([eE][+-]?\d+)?$/, input_str) ->
        :erlang.binary_to_float(String.strip(input_str))
      true -> :error
    end
  end

  def get_dimensions(n1, n2) do
    { get_number(n1), get_number(n2) }
  end

  def calculate(shape, d1, d2) do
    cond do
      shape == :unknown -> IO.puts("Unknown shape #{d1}")
      d1 < 0 or d2 < 0 -> IO.puts("Both numbers must be greater than or equal to zero.")
      true -> Geom.area(shape, d1, d2)
    end
  end
end
