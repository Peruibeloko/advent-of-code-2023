alias AdventOfCode.Utils

defmodule AdventOfCode.Day7.Part1 do
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

  def compare_hands(hand_a, hand_b) do
    card_pairs = Enum.zip(String.graphemes(hand_a), String.graphemes(hand_b))
    compare_hands(card_pairs)
  end

  def compare_hands([{card_a, card_b} | remaining_pairs]) do
    card_strength = %{
      "A" => 13,
      "K" => 12,
      "Q" => 11,
      "J" => 10,
      "T" => 9,
      "9" => 8,
      "8" => 7,
      "7" => 6,
      "6" => 5,
      "5" => 4,
      "4" => 3,
      "3" => 2,
      "2" => 1
    }

    strength_a = card_strength[card_a]
    strength_b = card_strength[card_b]

    cond do
      strength_a === strength_b ->
        compare_hands(remaining_pairs)

      strength_a < strength_b ->
        true

      true ->
        false
    end
  end

  def sort_games({hand_a, score_a, _}, {hand_b, score_b, _}) do
    if score_a !== score_b do
      score_a <= score_b
    else
      compare_hands(hand_a, hand_b)
    end
  end

  def total_winnings([{_, _, bid} | remaining_games]) do
    total_winnings(remaining_games, 2, bid)
  end

  def total_winnings([{_, _, bid} | remaining_games], current_rank, running_total) do
    total_winnings(remaining_games, current_rank + 1, bid * current_rank + running_total)
  end

  def total_winnings([], _, running_total) do
    running_total
  end

  def line_parser(line) do
    [hand, bid_string] = String.split(line, " ")
    bid = String.to_integer(bid_string)
    {hand, get_hand_score(hand), bid}
  end

  def run(file_name) do
    file_name
    |> Utils.parse_lines(&line_parser/1)
    |> Enum.sort(&sort_games/2)
    |> total_winnings()
    |> IO.inspect()
  end
end
