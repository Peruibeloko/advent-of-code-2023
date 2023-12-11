symbols_regex = ~r/\*/
number_regex = ~r/[1-9][0-9]{0,2}/

is_valid_offset = fn {x, y} ->
  x >= 0 and y >= 0 and x < 140 and y < 140
end

string_pos_to_xy = fn {idx, length} ->
  x = rem(idx, 140)
  y = div(idx, 140)
  {x, y, length}
end

xy_to_string_pos = fn {x, y} ->
  x + y * 140
end

kernel1 = fn {x, y} ->
  [
    {x - 1, y - 1},
    {x, y - 1},
    {x + 1, y - 1},
    {x - 1, y},
    {x + 1, y},
    {x - 1, y + 1},
    {x, y + 1},
    {x + 1, y + 1}
  ]
  |> Enum.filter(is_valid_offset)
end

kernel2 = fn {x, y} ->
  [
    {x - 1, y - 1},
    {x, y - 1},
    {x + 1, y - 1},
    {x + 2, y - 1},
    {x - 1, y},
    {x + 2, y},
    {x - 1, y + 1},
    {x, y + 1},
    {x + 1, y + 1},
    {x + 2, y + 1}
  ]
  |> Enum.filter(is_valid_offset)
end

kernel3 = fn {x, y} ->
  [
    {x - 1, y - 1},
    {x, y - 1},
    {x + 1, y - 1},
    {x + 2, y - 1},
    {x + 3, y - 1},
    {x - 1, y},
    {x + 3, y},
    {x - 1, y + 1},
    {x, y + 1},
    {x + 1, y + 1},
    {x + 2, y + 1},
    {x + 3, y + 1}
  ]
  |> Enum.filter(is_valid_offset)
end

get_kernel = fn length ->
  case length do
    1 -> kernel1
    2 -> kernel2
    3 -> kernel3
  end
end

test_pos = fn string, xy, regex ->
  pos = xy_to_string_pos.(xy)

  result =
    string
    |> String.at(pos)
    |> String.match?(regex)

    if result do
      xy
    else
    result
  end
end

search_offsets = fn offsets, string, regex ->
  offsets
  |> Enum.map(&test_pos.(string, &1, regex))
  |> Enum.filter(&(&1 !== false))
end

has_symbol_around? = fn {x, y, num_length}, string ->
  num_length
  |> get_kernel.()
  |> apply([{x, y}])
  |> search_offsets.(string, symbols_regex)
end

match_array_to_map = fn {key, val}, map ->
  Map.update(map, key, [val], &[val | &1])
end

{_, contents} = File.read("input.txt")

input = String.replace(contents, "\n", "")

match_pos_array = Regex.scan(number_regex, input, return: :index)
match_num_array = Regex.scan(number_regex, input) |> Enum.map(&hd/1)

match_pos_array
|> Enum.map(fn el ->
  el
  |> hd()
  |> string_pos_to_xy.()
  |> has_symbol_around?.(input)
end)
|> Enum.zip(match_num_array)
|> Enum.filter(&(Enum.count(elem(&1, 0)) > 0))
|> Enum.map(&{hd(elem(&1, 0)), elem(&1, 1)})
|> Enum.reduce(%{}, match_array_to_map)
|> Map.values()
|> Enum.filter(&(Enum.count(&1) === 2))
|> Enum.map(fn part_numbers ->
  part_numbers
  |> Enum.map(&String.to_integer/1)
  |> Enum.product()
end)
|> Enum.sum()
|> IO.puts()
