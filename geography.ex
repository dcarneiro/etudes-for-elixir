defmodule Country do
  defstruct name: "", language: "", cities: []
end

defmodule Geography do
  def make_geo_list(file_name) do
    {_result, device} = File.open(file_name, [:read, :utf8])
    process_line(device, [])
  end

  def total_population(list, language) do
    list |> Enum.filter(fn country -> country.language == language end)
      |> Enum.flat_map(fn country -> country.cities end)
      |> Enum.map(fn c -> c.population end)
      |> Enum.sum
  end

  defp process_line(device, geo_list) do
    data = IO.read(device, :line)
    case data do
      :eof ->
        File.close(device)
        geo_list
      _ ->
        info = String.split(String.strip(data), ",")
        updated_list = process_info(info, geo_list)
        process_line(device, updated_list)
    end
  end

  defp process_info([country, language], geo_list) do
    [%Country{name: country, language: language, cities: []}|geo_list]
  end

  defp process_info([name, population, latitude, longitude], [head|tail]) do
    new_cities = [%City{name: name, population: String.to_integer(population),
      latitude: String.to_float(latitude), longitude: String.to_float(longitude)}| head.cities]
    [%Country{head | cities: new_cities} | tail]
  end
end

