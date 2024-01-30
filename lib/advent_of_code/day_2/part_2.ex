alias AdventOfCode.Utils

defmodule AdventOfCode.Day2.Part2 do
  def game_set_to_list(set) do
    [count_str, color] = String.split(set, " ")
    {String.to_integer(count_str), color}
  end

  def upsert_color_map({count, color}, acc) do
    Map.update(acc, color, count, &max(&1, count))
  end

  def line_parser(line) do
    [_, game_string] =
      line
      |> String.replace("Game ", "")
      |> String.split(": ")

    game_string
    |> String.replace(";", ",")
    |> String.split(", ")
    |> Enum.map(&game_set_to_list/1)
    |> Enum.reduce(%{}, &upsert_color_map/2)
    |> Map.values()
    |> Enum.product()
  end

  def run(file_name) do
    file_name
    |> Utils.parse_lines(&line_parser/1)
    |> Enum.sum()
    |> IO.puts()
  end
end
