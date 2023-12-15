{_, contents} = File.read("input.txt")

defmodule Logging do
  def pretty_print(data, label \\ "") do
    IO.inspect(data,
      label: label,
      pretty: true,
      syntax_colors: IO.ANSI.syntax_colors(),
      charlists: :as_lists
    )
  end
end

defmodule Almanac do
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
        dest_start..(dest_start + (range_length - 1))
      )
    end)
  end

  def seed_pair_to_range(input) do
    pair_to_seed_list = fn [range_start, range_length] ->
      range_start..(range_start + (range_length - 1))
    end

    input
    |> Enum.chunk_every(2)
    |> Enum.map(pair_to_seed_list)
  end

  def parse([raw_seeds | raw_maps]) do
    seeds =
      raw_seeds
      |> hd()
      |> String.split(": ")
      |> tl()
      |> hd()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
      |> seed_pair_to_range()

    maps =
      raw_maps
      |> Enum.map(&parse_raw_map/1)

    {seeds, maps}
  end

  def split_over_ranges(input_start..input_end, input_stage) do
    slice_indices = input_stage
    |> Map.keys()
    |> Enum.reduce([], fn range_start..range_end, slice_indices ->
      # How to find the index of
    end)
  end

  def process_transformations({seeds, stages}) do
    stage_affects_seed_range? = fn {input, _}, range_start..range_end ->
      Enum.member?(input, range_start) or Enum.member?(input, range_end)
    end

    Enum.reduce(stages, seeds, fn current_stage, previous_result ->
      Enum.map(previous_result, fn range_to_transform ->
        affecting_stage_ranges = Enum.filter(current_stage, &stage_affects_seed_range?.(&1, range_to_transform))
        split_input = split_over_ranges(range_to_transform, affecting_stage_ranges)
      end)
    end)
  end
end

contents
|> String.split("\n")
|> Enum.chunk_by(&(&1 === ""))
|> Enum.filter(&(&1 !== [""]))
|> Almanac.parse()
|> Almanac.process_transformations()
|> Logging.pretty_print("\n\n---\nRecommended location")
