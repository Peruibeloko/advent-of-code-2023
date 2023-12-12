{_, contents} = File.read("test.txt")

parse_line = fn line ->
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
  |> then(&(&1 ++ [1]))
end

binary_search = fn term, array ->
  do_binary_search = fn term, array, rec ->
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

update_games = fn [winners, bets, multiplier], count ->
  [winners, bets, multiplier + count]
end

calculate_points = fn games ->
  do_calculate_points = fn
    result, [], _ ->
      result

    result, [[winners, bets, multiplier] | remaining_games], rec ->
      IO.inspect(remaining_games)

      matches =
        winners
        |> Enum.filter(&binary_search.(&1, bets))
        |> Enum.count()

      # IO.puts("#{matches}, #{multiplier}")

      updated_games =
        Enum.slice(remaining_games, 0, matches)
        |> Enum.map(&update_games.(&1, multiplier))

      rec.(result + multiplier, Enum.drop(remaining_games, matches) ++ updated_games, rec)
  end

  do_calculate_points.(0, games, do_calculate_points)
end

# games = [
#   [[winning numbers], [your numbers], multiplier],
#   [[winning numbers], [your numbers], multiplier],
#   [[winning numbers], [your numbers], multiplier],
# ]

games =
  contents
  |> String.split("\n")
  |> Enum.map(parse_line)

tally = calculate_points.(games)

IO.puts("\n---\nTotal: #{tally}")

# Pra cada numero ganhador, busca binária nas apostas
# Pontos = 2 ^ (n - 1)
