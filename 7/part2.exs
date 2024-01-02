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

    frequencies =
      hand
      |> String.graphemes()
      |> Enum.frequencies()

    j_count =
      if Map.has_key?(frequencies, "J") do
        frequencies["J"]
      else
        0
      end

    final_frequencies =
      if j_count === 5 do
        [j_count]
      else
        [most_frequent | rest] =
          frequencies
          |> Map.filter(fn {k, _} -> k !== "J" end)
          |> Map.values()
          |> Enum.sort(:desc)
          |> dbg()

        [most_frequent + j_count | rest]
      end

    get_score.(final_frequencies)
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
      "T" => 10,
      "9" => 9,
      "8" => 8,
      "7" => 7,
      "6" => 6,
      "5" => 5,
      "4" => 4,
      "3" => 3,
      "2" => 2,
      "J" => 1
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

  def parse_file(file_contents) do
    parse_line = fn line ->
      [hand, bid_string] = String.split(line, " ")
      bid = String.to_integer(bid_string)
      {hand, get_hand_score(hand), bid}
    end

    file_contents
    |> String.split("\n")
    |> Enum.map(parse_line)
    |> Enum.sort(&sort_games/2)
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
end

{_, contents} = File.read("input.txt")

Solution.parse_file(contents)
|> Solution.total_winnings()
|> IO.inspect()
