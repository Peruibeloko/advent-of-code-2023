{_status, contents} = File.read("input.txt")

symbols_regex = ~r/\*\-\%\/\#\&\$\=\@\+/
number_regex = ~r/\d{1,3}/

get_pos = fn matrix, {x, y} ->
  matrix[y][x]
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

get_kernel = fn len ->
  case len do
    1 -> kernel1
    2 -> kernel2
    3 -> kernel3
  end
end

apply_kernel = fn matrix, kernel, regex ->
  first_row = Enum.get(kernel, 0)
  second_row = Enum.get(kernel, 1) |> &(Enum.get(&1, 0) ++ Enum.get(&1, -1))
  third_row = Enum.get(kernel, 2)

  [first_row, second_row, third_row]
  |> Enum.map(fn row ->
    row
    |> Enum.map(&(get_pos.(matrix, &1)))
    |> Enum.map(&(Regex.match(regex, &1)))
    |> Enum.all?
  end)
  |> Enum.all?
end

has_symbol_around? = fn matrix, {x, y}, num_length ->
  kernel = get_kernel.(num_length)
  positions = kernel.({x, y})
  apply_kernel.(matrix, positions, symbols_regex)
end

matrix = contents
|> String.split("\n")
|> Enum.map(String.graphemes)


Regex.scan(contents, number_regex, return: :index)



# Procura os números
# Em torno de cada número, procurar um símbolo
# Descartar os números que não possuem um símbolo ao redor
# Somar o resto
