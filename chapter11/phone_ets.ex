defmodule Phone do
  require Record

  Record.defrecord :phone, [
    number: "",
    starting_date: "1900-01-01",
    starting_time: "00:00:00",
    end_date: "1900-01-01",
    end_time: "00:00:00"
  ]
end

defmodule PhoneEts do
  require Phone

  @doc """
  Read from a file and construct a corresponding ETS table
  """
  def setup(filename) do
    case :ets.info(:call_table) do
      :undefined -> false
      _ -> :ets.delete(:call_table)
    end

    :ets.new(:call_table, [
      :named_table, :bag, { :keypos, Phone.phone(:number) + 1 }
    ])

    {result, input_file} = File.open(filename)
    if result == :ok do
      add_rows(input_file)
    end
  end

  def add_rows(input_file) do
    data = IO.read(input_file, :line)
    case data do
      :eof ->
        :ok
      _ ->
        [number, sdate, stime, edate, etime] = String.split(String.strip(data), ",")
        :ets.insert(:call_table, Phone.phone(
          number: number,
          starting_date: gregorianize(sdate, "-"),
          starting_time: gregorianize(stime, ":"),
          end_date: gregorianize(edate, "-"),
          end_time: gregorianize(etime, ":")
        ))
        add_rows(input_file)
    end
  end

  @doc """
  Summarize the number of minutes that the phone number was on call
  """
  @spec summary(String.t) :: list(tuple(String.t, integer))

  def summary(phone_number) do
    [calculate(phone_number)]
  end

  @doc """
  Summarize the number of minutes for all the phone numbers
  """
  @spec summary() :: list(tuple(String.t, integer))

  def summary() do
    summary(:ets.first(:call_table), [])
  end

  defp summary(key, acc) do
    case key do
      :"$end_of_table" -> acc
      _ -> summary(:ets.next(:call_table, key),
        [calculate(key) | acc])
    end
  end

  defp gregorianize(str, delimiter) do
    :erlang.list_to_tuple(for item <- String.split(str, delimiter), do:
      String.to_integer(item))
  end

  # Calculate total number of minutes used by given phone number.
  # Returns tuple {phone_number, total}
  @spec calculate(String.t) :: {String.t, integer}

  defp calculate(phone_number) do
    calls = :ets.lookup(:call_table, phone_number)
    total = List.foldl(calls, 0, &call_minutes/2)
    {phone_number, total}
  end

  # Helper function for calculate; adds the number of minutes
  # for a given call to the accumulator
  @spec call_minutes(Phone.t, integer) :: integer

  defp call_minutes(phonecall, acc) do
    c_start = date_to_gregorian_seconds(
      {Phone.phone(phonecall, :starting_date),
      Phone.phone(phonecall, :starting_time)})
    c_end = date_to_gregorian_seconds(
      {Phone.phone(phonecall, :end_date),
      Phone.phone(phonecall, :end_time)})
    div((c_end - c_start) + 59, 60) + acc
  end

  # It return the number of seconds since the 0 year
  defp date_to_gregorian_seconds(datetime) do
    :calendar.datetime_to_gregorian_seconds datetime
  end
end