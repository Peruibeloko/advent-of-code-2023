alias AdventOfCode.Utils

defmodule AdventOfCode.Day10.Part2 do
  @verbose false

  def sanitize(input, pattern) do
    case Regex.run(pattern, input) do
      nil ->
        input

      _ ->
        result = String.replace(input, pattern, " ")
        sanitize(result, pattern)
    end
  end

  def join_vertical(lines) do
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

  def flip(input) do
    input
    |> Utils.split_lines()
    |> join_vertical()
  end

  @invalid_horizontal ~r/^[J7]|(?<=[ J7|])[-J7]|[LF-](?=[|FL ])|[FL]$/m
  @invalid_vertical ~r/^[J|L]|(?<=[ JL-])[J|L]|[7|F](?=[-7F ])|[7|F]$/m

  def cleanup_logic(input, should_run?, current_pattern, next_pattern) do
    if(should_run?) do
      sanitize(input, current_pattern)
    else
      input
    end
    |> flip()
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
      flip(input)
    end
  end

  def replace_at(string, range, replacement) do
    str_start = String.slice(string, 0..(range.first - 1))
    str_end = String.slice(string, (range.last + 1)..-1//1)
    spacing = String.duplicate(replacement, Range.size(range))

    if(@verbose, do: Utils.pretty_print("Replacing", {String.slice(string, range), spacing}))

    "#{str_start}#{spacing}#{str_end}"
  end

  def remove_squares(input) do
    size =
      input
      |> String.split(["\n", "\r\n"])
      |> Enum.count()

    possible_square_positions =
      Regex.scan(~r/(?<=\s)F7(?=\s)/m, input, return: :index)

    for [{pos, _}] <- possible_square_positions, reduce: input do
      output ->
        {upper_range, lower_range} = {pos..(pos + 1), (pos + size + 1)..(pos + size + 2)}

        square = String.slice(output, upper_range) <> String.slice(output, lower_range)

        if square === "F7LJ" do
          if @verbose do
            Utils.pretty_print("pos", pos)
            Utils.pretty_print("Ranges", [upper_range, lower_range])
            Utils.pretty_print("Square", square)
          end

          output
          |> replace_at(upper_range, " ")
          |> replace_at(lower_range, " ")
        else
          output
        end
    end
  end

  def trim_outer_dots(input) do
    outer_dots_pattern = ~r/ \K\.+|\.+(?= )/

    if(input =~ outer_dots_pattern) do
      input
      |> flip()
      |> Utils.replace_keep_size(outer_dots_pattern, " ")
      |> flip()
      |> Utils.replace_keep_size(outer_dots_pattern, " ")
      |> flip()
      |> trim_outer_dots()
    else
      input
    end
  end

  def count_inside_points(input) do
    for line <- Utils.split_lines(input), line =~ ~r/\.+/ do
      scan_result =
        ~r/\./
        |> Regex.scan(line, return: :index)
        |> Enum.map(&hd/1)

      for {pos, _} <- scan_result do
        line
        |> String.slice((pos + 1)..140)
        |> String.replace([".", " "], "")
        |> String.replace(~r/F-*J|L-*7/, "|")
        |> String.replace(~r/F-*7|L-*J/, "||")
        |> String.length()
        |> then(&(rem(&1, 2) !== 0))
      end
      |> Enum.count(&(&1 === true))
    end
    |> Enum.sum()
  end

  def run(file_name) do
    contents =
      file_name
      |> Utils.read_file()
      |> String.replace(~r/\./, " ")
      |> cleanup(@invalid_horizontal)
      |> remove_squares()
      |> Utils.replace_keep_size(~r/(?<=\S) +?(?=\S)/, ".")
      |> flip()
      |> Utils.replace_keep_size(~r/^ *\K\.+|\.+(?= *$)/m, " ")
      |> trim_outer_dots()
      |> count_inside_points()
      |> Utils.pretty_print()

    file_name
    |> Path.split()
    |> Enum.reverse()
    |> tl()
    |> Enum.reverse()
    |> Enum.concat(["result.txt"])
    |> Path.join()
    |> File.write(contents)
  end
end
