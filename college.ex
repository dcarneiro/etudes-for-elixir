defmodule College do
  def make_room_list(path) do
    {_result, device} = File.open(path, [:read, :utf8])
    room_list = HashDict.new()
    process_line(device, room_list)
  end

  # Read next line from file; if not end of file, process
  # the room on that line. Recursively read through end of file
  defp process_line(device, room_list) do
    data = IO.read(device, :line)
    case data do
      :eof ->
        File.close(device)
        room_list
      _ ->
        updated_list = process_room(data, room_list)
        process_line(device, updated_list)
    end
  end

  # Extract information from a line in the file, and append
  # course to hash dictionary value for the given room.
  defp process_room(line, room_list) do
    [_id, course, room] = line |> String.strip |> String.split(",")
    course_list = HashDict.get(room_list, room)
    case course_list do
      nil -> HashDict.put_new(room_list, room, [course])
      _ -> HashDict.put(room_list, room, [course|course_list])
    end
  end
end
