defmodule Solution do
  def pretty_print(data) do
    IO.inspect(data,
      pretty: true,
      syntax_colors: IO.ANSI.syntax_colors(),
      charlists: :as_lists
    )
  end

  def pretty_print(label, data) do
    IO.inspect(data,
      label: label,
      pretty: true,
      syntax_colors: IO.ANSI.syntax_colors(),
      charlists: :as_lists
    )
  end

  def parse_line(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def parse_file(file) do
    file
    |> String.split(["\n", "\r\n"])
    |> Enum.map(&parse_line/1)
  end

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

  def process_line(line) do
    line
    |> Enum.reverse()
    |> create_regressions([])
    |> Enum.map(&Enum.reverse/1)
    |> generate_predictions([])
    |> hd()
  end
end

{_, contents} = File.read("input.txt")

contents
|> Solution.parse_file()
|> Enum.map(&Solution.process_line/1)
|> Enum.sum()
|> IO.puts()
