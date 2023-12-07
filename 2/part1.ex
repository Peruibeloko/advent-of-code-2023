{_status, contents} = File.read("test2.txt")

game_set_to_list = fn set ->
  [count_str, color] = String.split(set, " ")
  [String.to_integer(count_str), color]
end

upsert_color_map = fn [count, color], acc ->
  Map.update(acc, color, count, &(&1 + count))
end

#todo
is_compatible = fn subject, reference ->
  subject_map = elem(subject, 1)

  Map.keys(subject_map)
  |> Enum.reduce(true, fn color, acc -> acc and subject_map[color] <= reference[color] end)
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
|> String.split("\r\n")
|> Enum.map(parse_line)
|> Enum.filter(&(is_compatible.(&1, reference)))
|> Enum.map(&(elem(&1, 0)))
|> Enum.join("\n")
|> IO.puts()
