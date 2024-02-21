alias AdventOfCode.Utils
alias AdventOfCode.Utils.Repo

defmodule AdventOfCode.Day11.Part1 do
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

  def manhattan_disance({{x1, y1}, {x2, y2}}) do
    abs(x2 - x1) + abs(y2 - y1)
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
        if line =~ ~r/^\.+$/ do
          out ++ [line, line]
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
      |> Enum.map(&manhattan_disance/1)

    Utils.pretty_print("Sum of distances", Enum.sum(distances))
  end
end

# A contagem de pares segue o coeficiente binomial C(n,2), onde N é o número de galáxias:
# c = (n * n - 1) / 2

# A distancia entre cada par de galáxias segue a distância manhattan:
# d = abs(p1.x - p2.x) + abs(p1.y - p2.y)
