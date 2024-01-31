alias AdventOfCode.Utils

defmodule AdventOfCode.Day10.Part1Alt do
  defp sanitize(input, pattern) do
    case Regex.run(pattern, input) do
      nil ->
        input

      _ ->
        result = String.replace(input, pattern, " ")
        sanitize(result, pattern)
    end
  end

  defp join_vertical(lines) do
    for pos <- 0..(Enum.count(lines) - 1), reduce: [] do
      output ->
        Enum.concat(
          output,
          [
            for line <- lines, reduce: "" do
              string -> string <> String.at(line, pos)
            end
          ]
        )
    end
    |> Enum.join("\n")
  end

  @invalid_horizontal ~r/(?<=[ J7|])[-J7]|[LF-](?=[|FL ])/
  @invalid_vertical ~r/(?<=[ JL-])[J|L]|[7|F](?=[-7F ])/

  def cleanup_logic(input, should_run?, current_pattern, next_pattern) do
    if(should_run?) do
      sanitize(input, current_pattern)
    else
      input
    end
    |> Utils.split_lines()
    |> join_vertical()
    |> cleanup(next_pattern)
  end

  def cleanup(input, @invalid_horizontal) do
    should_run? = Regex.run(@invalid_horizontal, input) !== nil

    if should_run? do
      cleanup_logic(input, should_run?, @invalid_horizontal, @invalid_vertical)
    else
      input
    end
  end

  def cleanup(input, @invalid_vertical) do
    should_run? = Regex.run(@invalid_vertical, input) !== nil

    if should_run? do
      cleanup_logic(input, should_run?, @invalid_vertical, @invalid_horizontal)
    else
      input
      |> Utils.split_lines()
      |> join_vertical()
    end
  end

  def run(file_name) do
    file_name
    |> Utils.read_file()
    |> String.replace(~r/\./, " ")
    |> cleanup(@invalid_horizontal)
    |> IO.puts()
  end
end
