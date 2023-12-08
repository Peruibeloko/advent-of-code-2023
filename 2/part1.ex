{_status, contents} = File.read("input.txt")

game_set_to_list = fn set ->
  [count_str, color] = String.split(set, " ")
  [String.to_integer(count_str), color]
end

upsert_color_map = fn [count, color], acc ->
  Map.update(acc, color, count, &(max(&1, count)))
end

is_compatible = fn subject, reference ->
  subject_map = elem(subject, 1)

  Map.keys(subject_map)
  |> Enum.map(&(Map.get(subject_map, &1) <= Map.get(reference, &1)))
  |> Enum.reduce(true, &(&1 and &2))
end

parse_line = fn line ->
  [game_id, game_string] = String.split(line, ": ")

  game_data =
    game_string
    |> String.replace(";", ",")
    |> String.split(", ")
    |> Enum.map(game_set_to_list)
    |> Enum.reduce(%{}, upsert_color_map)

  {String.to_integer(game_id), game_data}
end

reference = %{
  "red" => 12,
  "green" => 13,
  "blue" => 14
}

contents
|> String.replace("Game ", "")
|> String.split("\n")
|> Enum.map(parse_line)
|> Enum.filter(&(is_compatible.(&1, reference)))
|> Enum.map(&(elem(&1, 0)))
|> Enum.sum
|> IO.puts()
