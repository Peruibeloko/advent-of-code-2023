{_status, contents} = File.read("input.txt")

symbols_regex = ~r/\*\-\%\/\#\&\$\=\@\+/
number_regex = ~r/\d{1,3}/

get_pos = fn matrix, {x, y} ->
  matrix
  |> Enum.at(y)
  |> Enum.at(x)
end

kernel1 = fn {x, y} ->
  [
    [{x-1, y-1}, {x, y-1}, {x+1, y-1}],
    [{x-1, y  }, {x, y  }, {x+1, y  }],
    [{x-1, y+1}, {x, y+1}, {x+1, y+1}]
  ]
end

kernel2 = fn {x, y} ->
  [
    [{x-1, y-1}, {x, y-1}, {x+1, y-1}, {x+2, y-1}],
    [{x-1, y  }, {x, y  }, {x+1, y  }, {x+2, y  }],
    [{x-1, y+1}, {x, y+1}, {x+1, y+1}, {x+2, y+1}]
  ]
end

kernel3 = fn {x, y} ->
  [
    [{x-1, y-1}, {x, y-1}, {x+1, y-1}, {x+2, y-1}, {x+3, y-1}],
    [{x-1, y  }, {x, y  }, {x+1, y  }, {x+2, y  }, {x+3, y  }],
    [{x-1, y+1}, {x, y+1}, {x+1, y+1}, {x+2, y+1}, {x+3, y+1}]
  ]
end

kernel_factory = fn len ->
  case len do
    1 -> kernel1
    2 -> kernel2
    3 -> kernel3
  end
end

is_valid_offset = fn {x, y} ->
  x >= 0 and y >= 0 and x <= 140 and y <= 140
end

search_offsets = fn matrix, offsets, regex ->
  first_row =
    offsets
    |> Enum.at(0)
    |> Enum.filter(is_valid_offset)

  second_row =
    offsets
    |> Enum.at(1)
    |> then(&([Enum.at(&1, 0), Enum.at(&1, -1)]))
    |> Enum.filter(is_valid_offset)

  third_row =
    offsets
    |> Enum.at(2)
    |> Enum.filter(is_valid_offset)

  [first_row, second_row, third_row]
  |> Enum.filter(&(Enum.count(&1) > 0))
  |> Enum.map(fn row ->
    row
    |> Enum.map(&(get_pos.(matrix, &1)))
    |> Enum.map(&(Regex.match?(regex, &1)))
    |> Enum.all?
  end)
  |> Enum.all?
end

has_symbol_around? = fn matrix, {x, y, num_length} ->
  kernel = kernel_factory.(num_length)
  offsets = kernel.({x, y})
  search_offsets.(matrix, offsets, symbols_regex)
end

string_match_to_pos = fn {idx, length} ->
  x = rem(idx, 140)
  y = div(idx, 140)
  {x, y, length}
end

matrix = contents
|> String.split("\n")
|> Enum.map(&String.graphemes/1)


Regex.scan(number_regex, contents, return: :index)
|> Enum.map(&hd/1)
|> Enum.map(string_match_to_pos)
|> Enum.map(&has_symbol_around?.(matrix, &1))
|> IO.puts

# Procura os números
# Em torno de cada número, procurar um símbolo
# Descartar os números que não possuem um símbolo ao redor
# Somar o resto
