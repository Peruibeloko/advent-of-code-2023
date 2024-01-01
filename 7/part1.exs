defmodule Solution do
  def get_hand_score(hand) do
    get_score = fn
      [5] -> 7
      [4, 1] -> 6
      [3, 2] -> 5
      [3, 1, 1] -> 4
      [2, 2, 1] -> 3
      [2, 1, 1, 1] -> 2
      [1, 1, 1, 1, 1] -> 1
    end

    hand
    |> String.graphemes()
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
    |> get_score.()
  end

  def compare_hands({_, score_a, _}, {_, score_b, _}) when score_a !== score_b do
    score_a >= score_b
  end

  def compare_hands({hand_a, _, _}, {hand_b, _, _}) do
    card_values = %{
      "2" => 1,
      "3" => 2,
      "4" => 3,
      "5" => 4,
      "6" => 5,
      "7" => 6,
      "8" => 7,
      "9" => 8,
      "T" => 9,
      "J" => 10,
      "Q" => 11,
      "K" => 12,
      "A" => 13
    }

    Enum.zip(String.graphemes(hand_a), String.graphemes(hand_b))
    |> Enum.any?(fn
      {a, b} -> card_values[a] > card_values[b]
    end)
  end

  def parse_file(file_contents) do
    parse_line = fn line ->
      [hand, bid_string] = String.split(line, " ")
      bid = String.to_integer(bid_string)
      {hand, get_hand_score(hand), bid}
    end

    file_contents
    |> String.split("\n")
    |> Enum.map(parse_line)
    |> Enum.sort(&compare_hands/2)
  end
end

{_, contents} = File.read("test.txt")

Solution.parse_file(contents)
|> IO.inspect()
