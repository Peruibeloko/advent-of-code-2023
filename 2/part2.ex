{_status, contents} = File.read("input.txt")

game_set_to_list = fn set ->
  [count_str, color] = String.split(set, " ")
  {String.to_integer(count_str), color}
end

upsert_color_map = fn {count, color}, acc ->
  Map.update(acc, color, count, &(max(&1, count)))
end

parse_line = fn line ->
  [_, game_string] = String.split(line, ": ")

  game_string
  |> String.replace(";", ",")
  |> String.split(", ")
  |> Enum.map(game_set_to_list)
  |> Enum.reduce(%{}, upsert_color_map)
  |> Map.values
  |> Enum.product
end

contents
|> String.replace("Game ", "")
|> String.split("\n")
|> Enum.map(parse_line)
|> Enum.sum
|> IO.puts()
