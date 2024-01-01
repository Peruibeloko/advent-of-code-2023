defmodule Solution do
  def parse_races(file_contents) do
    parse_line = fn line ->
      line
      |> String.split(~r/\:\s+/)
      |> Enum.at(1)
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
    end

    file_contents
    |> String.split("\n")
    |> Enum.map(parse_line)
    |> Enum.zip()
  end

  def bhaskara(a, b, c) do
    delta = b * b - 4 * a * c

    x_1 = (-b + :math.sqrt(delta)) / (2 * a)
    x_2 = (-b - :math.sqrt(delta)) / (2 * a)
    {x_1, x_2}
  end

  def win_count_of_race({t_max, d_record}) do
    {l, r} = Solution.bhaskara(-1, t_max, -d_record)
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
end

{_, contents} = File.read("input.txt")

contents
|> Solution.parse_races()
|> Enum.map(&Solution.win_count_of_race/1)
|> Enum.product()
|> dbg()
