{_, contents} = File.read("test.txt")

defmodule Solution do
  def parse_races(file_contets) do
    parse_line = fn line ->
      line
      |> String.split(~r/\:\s+/)
      |> Enum.at(1)
      |> String.split(~r/\s+/)
      |> Enum.map(&String.to_integer/1)
    end

    file_contets
    |> String.split("\r\n")
    |> Enum.map(parse_line)
    |> Enum.zip()
  end

  def create_formula(a, b, c) do
    fn x -> :math.pow(x, 2) + b * x + c end
  end

  def bhaskara(a, b, c) do
    delta = b * b - 4 * a * c

    x_1 = (-b + :math.sqrt(delta)) / (2 * a)
    x_2 = (-b - :math.sqrt(delta)) / (2 * a)
    {x_1, x_2}
  end

  def win_count_of_race({t_max, d_record}) do
    {l, r} = Solution.bhaskara(-1, t_max, -d_record)
    Range.size(round(:math.ceil(l))..round(:math.floor(r)))
  end
end

races = Solution.parse_races(contents)

races
|> Enum.map(&Solution.win_count_of_race/1)
|> Enum.product()
|> IO.inspect()
