{_, contents} = File.read("test.txt")

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

defmodule Parsing do
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
        src_start..(src_start + range_length),
        dest_start
      )
    end)
  end

  def get_val(map, key) do
    map_keys =
      map
      |> Map.keys()

    is_special? =
      map_keys
      |> Enum.map(&(key in &1))
      |> Enum.any?()

    if is_special? do
      src_range = Enum.find(map_keys, &(key in &1))
      offset = key - src_range.first
      Map.get(map, src_range) + offset
    else
      key
    end
  end

  def parse_almanac([
        raw_seeds,
        raw_seed_soil,
        raw_soil_fert,
        raw_fert_water,
        raw_water_light,
        raw_light_temp,
        raw_temp_humi,
        raw_humi_location
      ]) do
    seeds =
      raw_seeds
      |> hd()
      |> String.split(": ")
      |> tl()
      |> hd()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    soil_map =
      raw_soil_fert
      |> parse_raw_map()

    seeds
    |> Enum.map(&get_val(soil_map, &1))
    |> Logging.pretty_print()
  end
end

contents
|> String.split("\n")
|> Enum.chunk_by(&(&1 === ""))
|> Enum.filter(&(&1 !== [""]))
|> Parsing.parse_almanac()

# |> Logging.pretty_print()
