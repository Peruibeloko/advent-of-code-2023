alias AdventOfCode.Day3.Offset

defmodule AdventOfCode.Day3.Part2 do
  @symbols_regex ~r/[*\-%\/#&$=@+]/
  @number_regex ~r/[1-9][0-9]{0,2}/

  def string_pos_to_xy({idx, length}, size) do
    x = rem(idx, size)
    y = div(idx, size)
    {x, y, length}
  end

  def xy_to_string_pos({x, y}, size) do
    x + y * size
  end

  def test_pos(string, xy, size, regex) do
    pos = xy_to_string_pos(xy, size)

    result =
      string
      |> String.at(pos)
      |> String.match?(regex)

    if result do
      xy
    else
      result
    end
  end

  def search_offsets(offsets, size, string, regex) do
    offsets
    |> Enum.map(&test_pos(string, &1, size, regex))
    |> Enum.filter(&(&1 !== false))
  end

  def has_symbol_around?({x, y, num_length}, bound, string) do
    num_length
    |> Offset.get_offset_factory()
    |> apply([{x, y}, bound])
    |> search_offsets(bound, string, @symbols_regex)
  end

  @spec match_array_to_map({any(), any()}, map()) :: map()
  def match_array_to_map({key, val}, map) do
    Map.update(map, key, [val], &[val | &1])
  end

  def run(file_name) do
    {_, contents} = File.read(file_name)

    line_length =
      contents
      |> String.split(["\n", "\r\n"])
      |> Enum.count()

    input = String.replace(contents, ["\n", "\r\n"], "")

    match_pos_array = Regex.scan(@number_regex, input, return: :index)
    match_num_array = Regex.scan(@number_regex, input) |> Enum.map(&hd/1)

    match_pos_array
    |> Enum.map(fn el ->
      el
      |> hd()
      |> string_pos_to_xy(line_length)
      |> has_symbol_around?(line_length, input)
    end)
    |> Enum.zip(match_num_array)
    |> Enum.filter(&(Enum.count(elem(&1, 0)) > 0))
    |> Enum.map(&{hd(elem(&1, 0)), elem(&1, 1)})
    |> Enum.reduce(%{}, &match_array_to_map/2)
    |> Map.values()
    |> Enum.filter(&(Enum.count(&1) === 2))
    |> Enum.map(fn part_numbers ->
      part_numbers
      |> Enum.map(&String.to_integer/1)
      |> Enum.product()
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end
