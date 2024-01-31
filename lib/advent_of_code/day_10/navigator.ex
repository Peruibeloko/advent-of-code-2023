defmodule AdventOfCode.Day10.Navigator do
  def to_xy(offset, size) do
    x = rem(offset, size)
    y = div(offset, size)
    {x, y}
  end

  def to_offset({x, y}, size) do
    x + y * size
  end

  def is_valid?({x, y}, size) do
    x >= 0 and x < size and y >= 0 and y < size
  end

  defp get_surroundings(directions, {size, input}) do
    for {direction, {x, y}} <- directions, is_valid?({x, y}, size), reduce: %{} do
      acc ->
        offset = to_offset({x, y}, size)
        character = String.at(input, offset)
        Map.put(acc, direction, character)
    end
  end

  defp check_surroundings(directions, text_params) do
    characters = get_surroundings(directions, text_params)

    cond do
      characters[:up] !== nil and characters.up =~ ~r/[|7FS]/ ->
        {:up, directions.up, characters.up}

      characters[:right] !== nil and characters.right =~ ~r/[-7JS]/ ->
        {:right, directions.right, characters.right}

      characters[:down] !== nil and characters.down =~ ~r/[|JLS]/ ->
        {:down, directions.down, characters.down}

      characters[:left] !== nil and characters.left =~ ~r/[-FLS]/ ->
        {:left, directions.left, characters.left}
    end
  end

  defp build_path_logic({current_character, directions_to_check}, text_params, path) do
    {
      chosen_direction,
      next_xy,
      next_character
    } =
      check_surroundings(directions_to_check, text_params)

    build_path(
      {next_character, next_xy},
      text_params,
      [{current_character, chosen_direction} | path]
    )
  end

  def build_path({"S", _}, _, path) when path !== [] do
    Enum.reverse(path)
  end

  def build_path({"S", {x, y}}, {size, input}, []) do
    directions_to_check = %{
      :up => {x, y - 1},
      :right => {x + 1, y},
      :down => {x, y + 1},
      :left => {x - 1, y}
    }

    build_path_logic({"S", directions_to_check}, {size, input}, [])
  end

  def build_path({character, {x, y}}, {size, input}, path) do
    [{_, last_step} | _] = path

    directions_to_check =
      case character do
        "-" ->
          %{:left => {x - 1, y}, :right => {x + 1, y}}

        "F" ->
          %{:down => {x, y + 1}, :right => {x + 1, y}}

        "7" ->
          %{:down => {x, y + 1}, :left => {x - 1, y}}

        "L" ->
          %{:up => {x, y - 1}, :right => {x + 1, y}}

        "|" ->
          %{:up => {x, y - 1}, :down => {x, y + 1}}

        "J" ->
          %{:up => {x, y - 1}, :left => {x - 1, y}}
      end

    backtrack =
      case last_step do
        :up -> :down
        :down -> :up
        :left -> :right
        :right -> :left
      end

    correct_directions = Map.drop(directions_to_check, [backtrack])
    build_path_logic({character, correct_directions}, {size, input}, path)
  end
end
