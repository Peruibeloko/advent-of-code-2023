alias AdventOfCode.Utils

defmodule AdventOfCode.Day1.Part2 do
  @names_to_digits %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  @number_names Map.keys(@names_to_digits)

  def sanitize(line, :left) do
    line
    |> String.replace(
      @number_names,
      &@names_to_digits[&1]
    )
    |> String.replace(~r/[[:alpha:]]/, "")
    |> String.at(0)
  end

  def sanitize(line, :right) do
    line
    |> String.reverse()
    |> String.replace(
      @number_names |> Enum.map(&String.reverse/1),
      &@names_to_digits[&1 |> String.reverse()]
    )
    |> String.replace(~r/[[:alpha:]]/, "")
    |> String.at(0)
  end

  def line_parser(line) do
    (sanitize(line, :left) <> sanitize(line, :right))
    |> String.to_integer()
  end

  def run(file_name) do
    file_name
    |> Utils.parse_lines(&line_parser/1)
    |> Enum.sum()
    |> IO.puts()
  end
end
