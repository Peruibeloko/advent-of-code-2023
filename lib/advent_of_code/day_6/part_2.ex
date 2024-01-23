alias AdventOfCode.Utils

defmodule AdventOfCode.Day6.Part2 do
  def bhaskara(a, b, c) do
    delta = b * b - 4 * a * c

    x_1 = (-b + :math.sqrt(delta)) / (2 * a)
    x_2 = (-b - :math.sqrt(delta)) / (2 * a)
    {x_1, x_2}
  end

  def win_count_of_race([t_max, d_record]) do
    {l, r} = bhaskara(-1, t_max, -d_record)
    rounded_l = ceil(l)
    rounded_r = floor(r)

    cond do
      l == rounded_l and r == rounded_r ->
        Range.size((rounded_r - 1)..(rounded_l + 1))

      l != rounded_l and r == rounded_r ->
        Range.size((rounded_r - 1)..rounded_l)

      l == rounded_l and r != rounded_r ->
        Range.size(rounded_r..(rounded_l + 1))

      l != rounded_l and r != rounded_r ->
        Range.size(rounded_r..rounded_l)
    end
  end

  def line_parser(line) do
    line
    |> String.split(~r/\:\s+/)
    |> Enum.at(1)
    |> String.split(~r/\s+/)
    |> Enum.join()
    |> String.to_integer()
  end

  def run(file_name) do
    file_name
    |> Utils.parse_file(&line_parser/1)
    |> win_count_of_race()
    |> dbg()
  end
end
