{_, contents} = File.read("input.txt")

pretty_print = fn data, label ->
  IO.inspect(data,
    label: label,
    pretty: true,
    syntax_colors: IO.ANSI.syntax_colors(),
    charlists: :as_lists
  )
end

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

update_game = fn [winners, bets, current_copies], copies_won ->
  [winners, bets, current_copies + copies_won]
end

calculate_points = fn games ->
  do_calculate_points = fn
    final_result, [], _ ->
      final_result

    final_result, [[winners, bets, copies_of_current_card] | remaining_games], rec ->

      games_won =
        winners
        |> Enum.filter(&binary_search.(&1, bets))
        |> Enum.count()

      updated_result = final_result + copies_of_current_card

      affected_games =
        Enum.slice(remaining_games, 0, games_won)
        |> Enum.map(&update_game.(&1, copies_of_current_card))

      next_games = affected_games ++ Enum.drop(remaining_games, Enum.count(affected_games))

      pretty_print.([winners, bets, copies_of_current_card], "---\ncurrent game")
      pretty_print.(games_won, "result of game")
      pretty_print.(updated_result, "running total")
      pretty_print.(next_games, "remaining games")

      rec.(updated_result, next_games, rec)
    end

  do_calculate_points.(0, games, do_calculate_points)
end

games =
  contents
  |> String.split("\n")
  |> Enum.map(parse_line)

tally = calculate_points.(games)

pretty_print.(tally, "---\nTotal card count")

# Pra cada numero ganhador, busca binária nas apostas
# Pontos = 2 ^ (n - 1)
