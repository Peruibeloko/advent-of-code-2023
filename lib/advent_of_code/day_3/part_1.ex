alias AdventOfCode.Day3.Offset

defmodule AdventOfCode.Day3.Part1 do
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

    string
    |> String.at(pos)
    |> String.match?(regex)
  end

  def search_offsets(offsets, size, string, regex) do
    offsets
    |> Enum.map(&test_pos(string, &1, size, regex))
    |> Enum.any?()
  end

  def has_symbol_around?({x, y, num_length}, bound, string) do
    num_length
    |> Offset.get_offset_factory()
    |> apply([{x, y}, bound])
    |> search_offsets(bound, string, @symbols_regex)
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
    |> Enum.map(&hd/1)
    |> Enum.map(&string_pos_to_xy(&1, line_length))
    |> Enum.map(&has_symbol_around?(&1, line_length, input))
    |> Enum.zip(match_num_array)
    |> Enum.filter(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
    |> IO.puts()
  end

  # Procura os números
  # Em torno de cada número, procurar um símbolo
  # Descartar os números que não possuem um símbolo ao redor
  # Somar o resto
end
