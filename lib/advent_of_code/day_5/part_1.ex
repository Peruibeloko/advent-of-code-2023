alias AdventOfCode.Utils

defmodule AdventOfCode.Day5.Part1 do
  def get_val(map, key) do
    is_special? =
      map
      |> Map.keys()
      |> Enum.map(&(key in &1))
      |> Enum.any?()

    Utils.pretty_print(is_special?, "is #{key} special?")

    if is_special? do
      src_range =
        map
        |> Map.keys()
        |> Enum.find(&(key in &1))

      offset = key - src_range.first
      Map.get(map, src_range) + offset
    else
      key
    end
  end

  def get_location(seed, maps) do
    Utils.pretty_print(seed, "\n\n---\ngetting location for seed")

    maps
    |> Enum.reduce(seed, fn current_map, prev_result ->
      Utils.pretty_print(prev_result, "---\ninput")
      Utils.pretty_print(current_map, "map")

      result = get_val(current_map, prev_result)

      Utils.pretty_print(result, "result")
    end)
  end

  def parse_raw_map([_ | map_values]) do
    split_spaces_parse_int = fn str ->
      str
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end

    map_values
    |> Enum.map(split_spaces_parse_int)
    |> Enum.reduce(%{}, fn [dest_start, src_start, range_length], map ->
      Map.put(
        map,
        src_start..(src_start + (range_length - 1)),
        dest_start
      )
    end)
  end

  def line_parser(line) do
    [raw_seeds | raw_maps] =
      line
      |> Enum.chunk_by(&(&1 === ""))
      |> Enum.filter(&(&1 !== [""]))

    maps =
      raw_maps
      |> Enum.map(&parse_raw_map/1)

    raw_seeds
    |> hd()
    |> String.split(": ")
    |> tl()
    |> hd()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&Almanac.get_location(&1, maps))
  end

  def run(file_name) do
    file_name
    |> Utils.parse_file(&line_parser/1)
    |> Enum.min()
    |> Utils.pretty_print("\n\n---\nRecommended location")
  end
end
