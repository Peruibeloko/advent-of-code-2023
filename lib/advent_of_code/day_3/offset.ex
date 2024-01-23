defmodule AdventOfCode.Day3.Offset do
  def get_offset_factory(length) do
    case length do
      1 -> &offset_1/2
      2 -> &offset_2/2
      3 -> &offset_3/2
    end
  end

  defp is_valid_offset?({x, y}, bound) do
    x >= 0 and y >= 0 and x < bound and y < bound
  end

  defp offset_1({x, y}, bound) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
    |> Enum.filter(&is_valid_offset?(&1, bound))
  end

  defp offset_2({x, y}, bound) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x + 2, y - 1},
      {x - 1, y},
      {x + 2, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1},
      {x + 2, y + 1}
    ]
    |> Enum.filter(&is_valid_offset?(&1, bound))
  end

  defp offset_3({x, y}, bound) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x + 2, y - 1},
      {x + 3, y - 1},
      {x - 1, y},
      {x + 3, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1},
      {x + 2, y + 1},
      {x + 3, y + 1}
    ]
    |> Enum.filter(&is_valid_offset?(&1, bound))
  end
end
