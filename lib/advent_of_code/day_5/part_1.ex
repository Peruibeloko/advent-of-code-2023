alias AdventOfCode.Utils

defmodule AdventOfCode.Day5.Part1 do
  def get_val(map, key) do
    is_special? =
      map
      |> Map.keys()
      |> Enum.map(&(key in &1))
      |> Enum.any?()

    Utils.pretty_print("is #{key} special?", is_special?)

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
    Utils.pretty_print("\n\n---\ngetting location for seed", seed)

    maps
    |> Enum.reduce(seed, fn current_map, prev_result ->
      Utils.pretty_print("---\ninput", prev_result)
      Utils.pretty_print("map", current_map)

      result = get_val(current_map, prev_result)

      Utils.pretty_print("result", result)
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

  def parse_file(file_name) do
    {_, content} = File.read(file_name)

    [[raw_seeds] | raw_maps] =
      content
      |> String.split(["\n", "\r\n"])
      |> Enum.chunk_by(&(&1 === ""))
      |> Enum.filter(&(&1 !== [""]))

    maps =
      raw_maps
      |> Enum.map(&parse_raw_map/1)

    [_ | [seeds_input]] = String.split(raw_seeds, ": ")

    seeds =
      seeds_input
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    {seeds, maps}
  end

  def run(file_name) do
    {seeds, maps} = parse_file(file_name)

    locations =
      for seed <- seeds do
        get_location(seed, maps)
      end

    closest_location =
      Enum.min(locations)

    Utils.pretty_print("\n\n---\nRecommended location", closest_location)
  end
end
