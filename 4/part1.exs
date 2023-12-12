{_, contents} = File.read("input.txt")

print_input = fn input ->
  print_line = fn line ->
    Enum.map(line, &Enum.join(&1, ", ")) |> Enum.join(" | ")
  end

  Enum.map(input, print_line)
  |> Enum.join("\n")
  |> IO.puts()
end

parse_line = fn line ->
  line |> IO.puts()

  line
  |> String.split(": ")
  |> tl()
  |> hd()
  |> String.split(" | ")
  |> Enum.map(fn list ->
    list
    |> String.trim()
    |> String.replace(~r/\b\s+/, " ")
    |> String.split(" ")
    |> Enum.map(&String.to_integer(&1))
    |> Enum.sort()
  end)
end

binary_search = fn term, array ->
  do_binary_search = fn term, array, rec ->
    IO.puts("#{term}, [#{Enum.join(array, ", ")}]\n")
    array_size = Enum.count(array)

    cond do
      array_size === 1 ->
        hd(array) === term

      array_size === 2 ->
        hd(array) === term || Enum.at(array, 1) === term

      true ->
        middle_pos = ceil(array_size / 2)
        middle_elem = Enum.at(array, middle_pos)

        cond do
          term === middle_elem ->
            true

          term > middle_elem ->
            rec.(term, Enum.slice(array, middle_pos..(array_size - 1)), rec)

          term < middle_elem ->
            rec.(term, Enum.slice(array, 0..(middle_pos - 1)), rec)
        end
    end
  end

  do_binary_search.(term, array, do_binary_search)
end

calculate_points = fn [winners, bets] ->
  matches =
    winners
    |> Enum.filter(&binary_search.(&1, bets))
    |> Enum.count()

  if matches === 0 do
    0
  else
    Integer.pow(2, matches - 1)
  end
end

# games = [
#   [[winning numbers], [your numbers]],
#   [[winning numbers], [your numbers]],
#   [[winning numbers], [your numbers]],
# ]

games =
  contents
  |> String.split("\n")
  |> Enum.map(parse_line)

print_input.(games)

tally =
  games
  |> Enum.map(calculate_points)
  |> Enum.sum()

IO.puts("\n---\nTotal: #{tally}")

# Pra cada numero ganhador, busca binária nas apostas
# Pontos = 2 ^ (n - 1)
