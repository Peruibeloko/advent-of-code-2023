alias AdventOfCode.Utils

defmodule AdventOfCode.Day9.Part2 do
  def next_regression([_], output) do
    Enum.reverse(output)
  end

  def next_regression([a | remainder], output) do
    b = hd(remainder)
    next_regression(remainder, [a - b | output])
  end

  def create_regressions(input, current_regressions) do
    filled_with? = fn list, val ->
      Enum.all?(list, &(&1 === val))
    end

    updated_regressions = [input] ++ current_regressions

    if input |> filled_with?.(0) do
      updated_regressions
    else
      regression = next_regression(input, [])
      create_regressions(regression, updated_regressions)
    end
  end

  def generate_predictions([], predictions) do
    predictions
  end

  def generate_predictions([_ | remaining], []) do
    generate_predictions(remaining, [0])
  end

  def generate_predictions([current | remaining], [0]) do
    generate_predictions(remaining, [hd(current), 0])
  end

  def generate_predictions([current | remaining], predictions) do
    last_value = hd(current)
    last_prediction = hd(predictions)
    generate_predictions(remaining, [last_value - last_prediction | predictions])
  end

  def line_parser(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.reverse()
    |> create_regressions([])
    |> Enum.map(&Enum.reverse/1)
    |> generate_predictions([])
    |> hd()
  end

  def run(file_name) do
    file_name
    |> Utils.parse_file(&line_parser/1)
    |> Enum.sum()
    |> IO.puts()
  end
end
