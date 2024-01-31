alias AdventOfCode.Utils

defmodule AdventOfCode.Day10.Part2 do
  defp sanitize(input, pattern) do
    case Regex.run(pattern, input) do
      nil ->
        input

      _ ->
        result = String.replace(input, pattern, " ")
        sanitize(result, pattern)
    end
  end

  defp join_vertical(lines) do
    for pos <- 0..(Enum.count(lines) - 1), reduce: [] do
      output ->
        Enum.concat(
          output,
          [
            for line <- lines, reduce: "" do
              string -> string <> String.at(line, pos)
            end
          ]
        )
    end
    |> Enum.join("\n")
  end

  @invalid_horizontal ~r/^[J7]|(?<=[ J7|])[-J7]|[LF-](?=[|FL ])|[FL]$/m
  @invalid_vertical ~r/^[J|L]|(?<=[ JL-])[J|L]|[7|F](?=[-7F ])|[7|F]$/m

  def cleanup_logic(input, should_run?, current_pattern, next_pattern) do
    if(should_run?) do
      sanitize(input, current_pattern)
    else
      input
    end
    |> Utils.split_lines()
    |> join_vertical()
    |> cleanup(next_pattern)
  end

  def cleanup(input, @invalid_horizontal) do
    should_run? = Regex.run(@invalid_horizontal, input) !== nil

    if should_run? do
      cleanup_logic(input, should_run?, @invalid_horizontal, @invalid_vertical)
    else
      input
    end
  end

  def cleanup(input, @invalid_vertical) do
    should_run? = Regex.run(@invalid_vertical, input) !== nil

    if should_run? do
      cleanup_logic(input, should_run?, @invalid_vertical, @invalid_horizontal)
    else
      input
      |> Utils.split_lines()
      |> join_vertical()
    end
  end

  def replace_at(string, range, replacement) do
    str_start = String.slice(string, 0..(range.first - 1))
    str_end = String.slice(string, (range.last + 1)..-1//1)
    spacing = String.duplicate(replacement, Range.size(range))
    Utils.pretty_print("Replacing", {String.slice(string, range), spacing})

    "#{str_start}#{spacing}#{str_end}"
  end

  def remove_squares(input) do
    size =
      input
      |> String.split(["\n", "\r\n"])
      |> Enum.count()

    possible_square_positions =
      Regex.scan(~r/(?<=\s)F7(?=\s)/m, input, return: :index)

    for [{pos, _}] <- possible_square_positions, reduce: input do
      output ->
        {upper_range, lower_range} = {pos..(pos + 1), (pos + size + 1)..(pos + size + 2)}

        square = String.slice(output, upper_range) <> String.slice(output, lower_range)

        if square === "F7LJ" do
          Utils.pretty_print("pos", pos)
          Utils.pretty_print("Ranges", [upper_range, lower_range])
          Utils.pretty_print("Square", square)

          output
          |> replace_at(upper_range, " ")
          |> replace_at(lower_range, " ")
        else
          output
        end
    end
  end

  def run(file_name) do
    contents =
      file_name
      |> Utils.read_file()
      |> String.replace(~r/\./, " ")
      |> cleanup(@invalid_horizontal)
      |> remove_squares()

    # TODO
    # ? Usar a regex (?<=\S) +(?=\S) para encontrar regiões de espaço em branco rodeadas
    # ? Usar os índices para testar por conectividade
    # ? Se dois alcances estão adjacentes em Y e seus alcances se interseccionam, eles estão conectados
    # ? Segmentar todas as regiões dessa maneira
    # ? Calcular os tamanhos
    # ? Pegar o maior
    # ? Talvez dê pra usar a rotação pra não usar regiões que estejam fora do loop

    file_name
    |> Path.split()
    |> Enum.reverse()
    |> tl()
    |> Enum.reverse()
    |> Enum.concat(["result.txt"])
    |> Path.join()
    |> File.write(contents)
  end
end
