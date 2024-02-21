alias AdventOfCode.Utils
alias AdventOfCode.Utils.Repo

defmodule AdventOfCode.Day11.Part2 do
  def make_unique_pairs(list) do
    make_pairs(list, [], [])
  end

  def make_pairs([e1 | remaining], used, out) do
    pairs =
      for e2 <- remaining -- used, reduce: out do
        acc -> [{e1, e2} | acc]
      end

    make_pairs(remaining, [e1 | used], pairs)
  end

  def make_pairs([], _, out) do
    out
  end

  def manhattan_disance({{x1, y1}, {x2, y2}}, lines, transposed) do
    current_line = Enum.at(lines, y1)
    current_col = Enum.at(transposed, x2)

    row =
      if x2 > x1 do
        String.slice(current_line, (x1 + 1)..x2)
      else
        String.slice(current_line, x2..(x1 - 1))
      end

    col = String.slice(current_col, (y1 + 1)..(y2 - 1))

    final_string = row <> col

    big_spaces =
      Regex.scan(~r/\*+/, final_string, return: :index)
      |> Enum.map(&hd/1)
      |> Enum.count()

    small_spaces =
      Regex.scan(~r/\.+/, final_string, return: :index)
      |> Enum.map(&hd/1)
      |> Enum.count()

    small_spaces + big_spaces * 10
  end

  def get_galaxy_coordinates(contents) do
    size = Repo.get(:size)

    contents
    |> Utils.find_all(~r/#/)
    |> Enum.map(fn {offset, _} -> Utils.to_xy(offset, size) end)
  end

  def expand(lines) do
    for line <- lines, reduce: [] do
      out ->
        if line =~ ~r/^[.*]+$/ do
          out ++ [Utils.replace_keep_size(line, ~r/^[.*]+$/, "*")]
        else
          out ++ [line]
        end
    end
  end

  def cosmic_expansion(lines) do
    lines
    |> expand()
    |> Utils.transpose_text_lines()
    |> expand()
    |> Utils.transpose_text_lines()
  end

  def run(file_name) do
    Repo.create()

    lines =
      file_name
      |> Utils.get_lines()
      |> cosmic_expansion()

    transposed = Utils.transpose_text_lines(lines)

    size =
      lines
      |> hd()
      |> String.length()

    Repo.put(size: size)

    distances =
      lines
      |> Enum.join()
      |> get_galaxy_coordinates()
      |> make_unique_pairs()
      |> Enum.map(&manhattan_disance(&1, lines, transposed))

    Utils.pretty_print("Sum of distances", Enum.sum(distances))
  end
end
