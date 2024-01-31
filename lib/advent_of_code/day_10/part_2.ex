alias AdventOfCode.Utils

defmodule AdventOfCode.Day10.Part2 do
  def line_parser(line) do
    line
  end

  def run(file_name) do
    file_name
    |> Utils.parse_lines(&line_parser/1)
  end
end
