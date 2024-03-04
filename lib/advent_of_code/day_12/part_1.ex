alias AdventOfCode.Utils

defmodule AdventOfCode.Day12.Part1 do
  def line_parser(line) do
    line_regex = ~r/^([.?#]+) (\d+(?:,\d+)+)$/
    [_, layout, count_string] = Regex.run(line_regex, line)

    count =
      count_string
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {layout, count}
  end

  def create_pattern_for_count(count) do
    arrangement =
      count
      |> Enum.map(&"(?:\#{#{&1}})")
      |> Enum.join("\\.+")

    {:ok, pattern} = Regex.compile("^\\.*#{arrangement}\\.*$")
    pattern
  end

  def create_tests(layout) do
    position_count =
      layout
      |> String.graphemes()
      |> Enum.frequencies()
      |> Map.get("?")

    Utils.pretty_print(2 ** position_count - 1)

    mask_list =
      0..(2 ** position_count - 1)
      |> Range.to_list()
      |> Enum.map(fn mask ->
        mask
        |> Integer.to_string(2)
        |> String.pad_leading(position_count, "0")
        |> String.reverse()
        |> String.replace("1", "#")
        |> String.replace("0", ".")
      end)

    match_indexes =
      Regex.scan(~r/\?/, layout, return: :index)
      |> Enum.map(fn el -> el |> hd() |> elem(0) end)

    for mask <- mask_list do
      for i <- 0..(Enum.count(match_indexes) - 1), reduce: layout do
        str ->
          index = Enum.at(match_indexes, i)
          sub = String.at(mask, i)

          Utils.replace_at(str, index, sub)
      end
    end
  end

  def run_tests(test_list, regex) do
    for test_case <- test_list, reduce: 0 do
      acc ->
        if Regex.match?(regex, test_case) do
          acc + 1
        else
          acc
        end
    end
  end

  def brute_force({layout, count}) do
    regex = create_pattern_for_count(count)
    test_list = create_tests(layout)
    run_tests(test_list, regex)
  end

  def run(file_name) do
    file_name
    |> Utils.parse_lines(&line_parser/1)
    |> Enum.map(&brute_force/1)
    |> Enum.sum()
    |> Utils.pretty_print()
  end
end
