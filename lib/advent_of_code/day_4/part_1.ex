alias AdventOfCode.Utils

defmodule AdventOfCode.Day4.Part1 do
  def print_input(input) do
    print_line = fn line ->
      Enum.map(line, &Enum.join(&1, ", ")) |> Enum.join(" | ")
    end

    Enum.map(input, print_line)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def calculate_points([winners, bets]) do
    matches =
      winners
      |> Enum.filter(&binary_search?(&1, bets))
      |> Enum.count()

    if matches === 0 do
      0
    else
      Integer.pow(2, matches - 1)
    end
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
      |> Enum.map(&String.to_integer(&1))
      |> Enum.sort()
    end)
  end

  def run(file_name) do
    games =
      file_name
      |> Utils.parse_file(&line_parser/1)

    print_input(games)

    tally =
      games
      |> Enum.map(&calculate_points/1)
      |> Enum.sum()

    IO.puts("\n---\nTotal: #{tally}")
  end
end

# games = [
#   [[winning numbers], [your numbers]],
#   [[winning numbers], [your numbers]],
#   [[winning numbers], [your numbers]],
# ]

# Pra cada numero ganhador, busca binária nas apostas
# Pontos = 2 ^ (n - 1)
