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

  def spinner() do
    IO.puts("|\r")
    IO.puts("/\r")
    IO.puts("-\r")
    IO.puts("\\\r")
    spinner()
  end
end

defmodule Almanac do
  def get_val(map, key) do
    map_keys =
      map
      |> Map.keys()

    is_special? =
      map_keys
      |> Enum.map(&(key in &1))
      |> Enum.any?()

    # Logging.pretty_print(is_special?, "is #{key} special?")

    if is_special? do
      src_range = Enum.find(map_keys, &(key in &1))
      offset = key - src_range.first
      Map.get(map, src_range) + offset
    else
      key
    end
  end

  def get_location(seed, maps) do
    # Logging.pretty_print(seed, "\n\n---\ngetting location for seed")

    maps
    |> Enum.reduce(seed, fn current_map, prev_result ->
      # Logging.pretty_print(prev_result, "---\ninput")
      # Logging.pretty_print(current_map, "map")
      result = get_val(current_map, prev_result)
      # Logging.pretty_print(result, "result")
      result
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

  def seed_pair_list_to_range(input) do
    pair_to_seed_list = fn [range_start, range_length] ->
      range_start..(range_start + (range_length - 1))
    end

    input
    |> Enum.chunk_every(2)
    |> Enum.map(pair_to_seed_list)
  end

  def min_location_of_seed_range(seed_range, maps) do
    Enum.reduce(seed_range, &min(&2, Almanac.get_location(&1, maps)))
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
      |> seed_pair_list_to_range()

    maps =
      raw_maps
      |> Enum.map(&parse_raw_map/1)

    {seeds, maps}
  end
end

contents
|> String.split("\n")
|> Enum.chunk_by(&(&1 === ""))
|> Enum.filter(&(&1 !== [""]))
|> Almanac.parse()
|> then(fn {seeds, maps} ->
  task_list = Enum.map(seeds, &Task.async(Almanac, :min_location_of_seed_range, [&1, maps]))
  Enum.map(task_list, &Task.await(&1, :infinity))
end)
|> Enum.min()
|> Logging.pretty_print("\n\n---\nRecommended location")
