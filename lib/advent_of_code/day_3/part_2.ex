# alias AdventOfCode.Utils
alias AdventOfCode.Day3.Offset

defmodule AdventOfCode.Day3.Part2 do
  @symbols_regex ~r/[*\-%\/#&$=@+]/
  @number_regex ~r/[1-9][0-9]{0,2}/

  def string_pos_to_xy({idx, length}) do
    x = rem(idx, 140)
    y = div(idx, 140)
    {x, y, length}
  end

  def xy_to_string_pos({x, y}) do
    x + y * 140
  end

  def test_pos(string, xy, regex) do
    pos = xy_to_string_pos(xy)

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

  def search_offsets(offsets, string, regex) do
    offsets
    |> Enum.map(&test_pos(string, &1, regex))
    |> Enum.filter(&(&1 !== false))
  end

  def has_symbol_around?({x, y, num_length}, string) do
    num_length
    |> Offset.get_offset_factory()
    |> apply([{x, y}])
    |> search_offsets(string, @symbols_regex)
  end

  def match_array_to_map({key, val}, map) do
    Map.update(map, key, [val], &[val | &1])
  end

  def run(file_name) do
    {_, contents} = File.read(file_name)

    input = String.replace(contents, "\n", "")

    match_pos_array = Regex.scan(@number_regex, input, return: :index)
    match_num_array = Regex.scan(@number_regex, input) |> Enum.map(&hd/1)

    match_pos_array
    |> Enum.map(fn el ->
      el
      |> hd()
      |> string_pos_to_xy()
      |> has_symbol_around?(input)
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
