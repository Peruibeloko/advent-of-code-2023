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

get_surrounding_contents = fn {x, y, length}, string ->
  left_bound =
    if x - 3 < 0 do
      0
    else
      x - 3
    end

  right_bound =
    if x + length + 3 >= 140 do
      139
    else
      x + length + 3
    end

  upper_bound =
    if y - 1 < 0 do
      0
    else
      y - 1
    end

  lower_bound =
    if y + 1 >= 140 do
      139
    else
      y + 1
    end

  slice_length = right_bound - left_bound

  slices = [
    {xy_to_string_pos.({left_bound, upper_bound}), slice_length},
    {xy_to_string_pos.({left_bound, y}), slice_length},
    {xy_to_string_pos.({left_bound, lower_bound}), slice_length}
  ]

  slices
  |> Enum.map(&String.slice(string, elem(&1, 0), elem(&1, 1)))
  |> Enum.join("\n")
  |> then(&IO.puts("#{&1}\n\n"))
end

{_, contents} = File.read("input.txt")

input = String.replace(contents, "\n", "")

match_pos_array = Regex.scan(symbols_regex, input, return: :index)
match_num_array = Regex.scan(number_regex, input) |> Enum.map(&hd/1)

match_pos_array
|> Enum.map(&hd/1)
|> Enum.map(&string_pos_to_xy.(&1))
|> Enum.map(&get_surrounding_contents.(&1, input))

# Procura os símbolos
# criar uma string representando a região em torno do símbolo usando slices concatenados
# slice(x-3, y-1), slice do meio, slice()
# String.match?()
# pegar só os com dois matches
# Produto
# soma dos produtos
