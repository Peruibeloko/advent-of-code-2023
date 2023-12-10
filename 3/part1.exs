symbols_regex = ~r/[*\-%\/#&$=@+]/
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

  string
  |> String.at(pos)
  |> String.match?(regex)
end

search_offsets = fn offsets, string, regex ->
  offsets
  |> Enum.map(&test_pos.(string, &1, regex))
  |> Enum.any?()
end

has_symbol_around? = fn {x, y, num_length}, string ->
  num_length
  |> get_kernel.()
  |> apply([{x, y}])
  |> search_offsets.(string, symbols_regex)
end

{_, contents} = File.read("input.txt")

input = String.replace(contents, "\n", "")

match_pos_array = Regex.scan(number_regex, input, return: :index)
match_num_array = Regex.scan(number_regex, input) |> Enum.map(&hd/1)

match_pos_array
|> Enum.map(&hd/1)
|> Enum.map(&string_pos_to_xy.(&1))
|> Enum.map(&has_symbol_around?.(&1, input))
|> Enum.zip(match_num_array)
|> Enum.filter(&elem(&1, 0))
|> Enum.map(&elem(&1, 1))
|> Enum.map(&String.to_integer/1)
|> Enum.sum()
|> IO.puts()

# Procura os números
# Em torno de cada número, procurar um símbolo
# Descartar os números que não possuem um símbolo ao redor
# Somar o resto
