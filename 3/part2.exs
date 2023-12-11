symbols_regex = ~r/\*/
number_regex = ~r/[1-9][0-9]{0,2}/

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
  |> IO.puts
end

{_, contents} = File.read("input.txt")

input = String.replace(contents, "\n", "")

Regex.scan(symbols_regex, input, return: :index)
|> Enum.map(fn matches ->
  matches
  |> hd()
  |> string_pos_to_xy.()
  |> then(&get_surrounding_contents.(&1, input))
  # |> then(&IO.puts("#{&1}\n"))
  |> then(&Regex.scan(number_regex, &1))
  |> Enum.map(&hd/1)
end)
|> Enum.filter(&(Enum.count(&1) === 2))
|> Enum.map(&Enum.product/1)
|> Enum.sum()
|> IO.puts()


# Regex por linhas
#....309|...*...|8..511.

# .{4}\d{1,3} \d{1,3}*\d{}


# ....309
# ...*...
# 8..511.
# ----------------------
# Procura os símbolos
# Criar uma string representando a região em torno do símbolo usando slices concatenados
# Match em números
# Filtrar os matches pelos com apenas 2 matches
# Produto
# Soma dos produtos
