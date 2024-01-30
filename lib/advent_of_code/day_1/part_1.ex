alias AdventOfCode.Utils

defmodule AdventOfCode.Day1.Part1 do
  def line_parser(line) do
    join_ends = fn line ->
      String.at(line, 0) <> String.at(line, -1)
    end

    line
    |> String.replace(~r/[[:alpha:]]/, "")
    |> join_ends.()
    |> String.to_integer()
  end

  def run(file_name) do
    file_name
    |> Utils.parse_lines(&line_parser/1)
    |> Enum.sum()
    |> IO.puts()
  end
end
