alias AdventOfCode.Utils
alias AdventOfCode.Day10.Navigator

defmodule AdventOfCode.Day10.Part1 do
  def run(file_name) do
    lines = Utils.get_lines(file_name)
    size = Enum.count(lines)
    input = Enum.join(lines)

    [{starting_offset, _}] = Regex.run(~r/S/, input, return: :index)
    starting_pos = Navigator.to_xy(starting_offset, size)
    path = Navigator.build_path({"S", starting_pos}, {size, input}, [])
    Utils.pretty_print("Total size", Enum.count(path))
    Utils.pretty_print("Farthest point", div(Enum.count(path), 2))
  end
end
