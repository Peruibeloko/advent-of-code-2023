alias AdventOfCode.Utils

defmodule AdventOfCode.Day4.Part2 do
  def calculate_points(games) do
    calculate_points(games, 0)
  end

  def calculate_points([], final_result) do
    final_result
  end

  def calculate_points(
        [[winners, bets, copies_of_current_card] | remaining_games],
        final_result
      ) do
    update_game = fn [winners, bets, current_copies], copies_won ->
      [winners, bets, current_copies + copies_won]
    end

    updated_result = final_result + copies_of_current_card

    games_won =
      winners
      |> Enum.filter(&binary_search?(&1, bets))
      |> Enum.count()

    affected_games =
      remaining_games
      |> Enum.slice(0, games_won)
      |> Enum.map(&update_game.(&1, copies_of_current_card))

    next_games = affected_games ++ Enum.drop(remaining_games, Enum.count(affected_games))

    Utils.pretty_print("---\ncurrent game", [winners, bets, copies_of_current_card])
    Utils.pretty_print("result of game", games_won)
    Utils.pretty_print("running total", updated_result)
    Utils.pretty_print("remaining games", next_games)

    calculate_points(next_games, updated_result)
  end

  def binary_search?(search_term, [last_element]) do
    IO.puts("#{search_term}, [#{last_element}]\n")
    last_element === search_term
  end

  def binary_search?(search_term, [second_last, last_element]) do
    IO.puts("#{search_term}, [#{second_last}, #{last_element}]\n")
    second_last === search_term || last_element === search_term
  end

  def binary_search?(search_term, array) do
    IO.puts("#{search_term}, [#{Enum.join(array, ", ")}]\n")
    array_size = Enum.count(array)

    middle_pos = ceil(array_size / 2)
    middle_elem = Enum.at(array, middle_pos)

    right_slice = Enum.slice(array, middle_pos..(array_size - 1))
    left_slice = Enum.slice(array, 0..(middle_pos - 1))

    cond do
      search_term === middle_elem ->
        true

      search_term < middle_elem ->
        binary_search?(search_term, left_slice)

      search_term > middle_elem ->
        binary_search?(search_term, right_slice)
    end
  end

  def line_parser(line) do
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
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
    end)
    |> then(&(&1 ++ [1]))
  end

  def run(file_name) do
    file_name
    |> Utils.parse_file(&line_parser/1)
    |> calculate_points()
    |> then(&Utils.pretty_print("---\nTotal card count", &1))
  end
end

# Pra cada numero ganhador, busca binária nas apostas
# Pontos = 2 ^ (n - 1)
