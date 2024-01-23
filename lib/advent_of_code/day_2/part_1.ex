alias AdventOfCode.Utils

defmodule AdventOfCode.Day2.Part1 do
  @reference %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  def game_set_to_list(set) do
    [count_str, color] = String.split(set, " ")
    [String.to_integer(count_str), color]
  end

  def upsert_color_map([count, color], acc) do
    Map.update(acc, color, count, &max(&1, count))
  end

  def is_compatible?(subject, @reference) do
    subject_map = elem(subject, 1)

    Map.keys(subject_map)
    |> Enum.map(&(Map.get(subject_map, &1) <= Map.get(@reference, &1)))
    |> Enum.reduce(true, &(&1 and &2))
  end

  def line_parser(line) do
    [game_id, game_string] =
      line
      |> String.replace("Game ", "")
      |> String.split(": ")

    game_data =
      game_string
      |> String.replace(";", ",")
      |> String.split(", ")
      |> Enum.map(&game_set_to_list/1)
      |> Enum.reduce(%{}, &upsert_color_map/2)

    {String.to_integer(game_id), game_data}
  end

  def run(file_name) do
    file_name
    |> Utils.parse_file(&line_parser/1)
    |> Enum.filter(&is_compatible?(&1, @reference))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
    |> IO.puts()
  end
end
