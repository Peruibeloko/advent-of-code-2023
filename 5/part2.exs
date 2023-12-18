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

defmodule Almanac do
  def parse_raw_map([_ | map_values]) do
    split_spaces_parse_int = fn str ->
      str
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end

    map_values
    |> Enum.map(split_spaces_parse_int)
    |> Enum.reduce([], fn [dest_start, src_start, range_length], map ->
      %{
        :input => src_start,
        :output => dest_start,
        :range => range_length
      }
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
end

contents
|> String.split("\n")
|> Enum.chunk_by(&(&1 === ""))
|> Enum.filter(&(&1 !== [""]))
|> Almanac.parse()
|> Logging.pretty_print("\n\n---\nRecommended location")
