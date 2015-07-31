defprotocol Valid do
  @doc "Returns true if data is considered blank/empty"
  def valid?(data)
end

defmodule City do
  defstruct name: "", population: 0, latitude: 0.0, longitude: 0.0
end

defimpl Valid, for: City do
  def valid?(%City{population: p, latitude: lat, longitude: lon}) do
    p > 0 && lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180
  end
end

defimpl Inspect, for: City do
  import Inspect.Algebra

  def inspect(city, _opts) do
    Enum.join [city.name, "(#{city.population})", lat(city), lon(city)], " "
  end

  def lat(city) do
    if (city.latitude < 0) do
      Enum.join [to_string(Float.round(abs(city.latitude * 1.0), 2)), "°S"]
    else
      Enum.join [to_string(Float.round(city.latitude * 1.0, 2)), "°N"]
    end
  end

  def lon(city) do
    if (city.longitude < 0) do
      Enum.join [to_string(Float.round(abs(city.longitude * 1.0), 2)), "°W"]
    else
      Enum.join [to_string(Float.round(city.longitude * 1.0, 2)), "°E"]
    end
  end
end