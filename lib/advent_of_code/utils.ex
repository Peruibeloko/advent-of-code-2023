defmodule AdventOfCode.Utils do
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

  def read_file(file_path) do
    file_path
    |> File.read()
    |> elem(1)
  end

  def read_file_no_breaks(file_path) do
    file_path
    |> File.read()
    |> elem(1)
    |> String.replace(["\n", "\r\n"], "")
  end

  def split_lines(string) do
    String.split(string, ["\n", "\r\n"])
  end

  def get_lines(file_path) do
    file_path
    |> File.read()
    |> elem(1)
    |> split_lines()
  end

  def parse_lines(file_path, line_parser) do
    file_path
    |> get_lines()
    |> Enum.map(line_parser)
  end

  def replace_keep_size(input, pattern, replacement) do
    input
    |> String.replace(pattern, fn match ->
      size = String.length(match)
      String.duplicate(replacement, size)
    end)
  end

  def to_xy(offset, size) do
    x = rem(offset, size)
    y = div(offset, size)
    {x, y}
  end

  def to_offset({x, y}, size) do
    y * size + x
  end

  def find_all(string, pattern) do
    pattern
    |> Regex.scan(string, return: :index)
    |> Enum.map(&hd/1)
  end

  def get_size(file_path) do
    lines =
      file_path
      |> get_lines()

    size_y = Enum.count(lines)

    size_x =
      lines
      |> hd()
      |> String.length()

    if(size_x === size_y, do: size_x, else: {size_x, size_y})
  end

  def transpose_matrix(matrix) do
    cols = matrix |> hd() |> Enum.count()

    for current_col <- (cols - 1)..0//-1, reduce: [] do
      transposed_cols ->
        current = Enum.reduce(matrix, [], &[Enum.at(&1, current_col) | &2])
        [Enum.reverse(current) | transposed_cols]
    end
  end

  def transpose_text(input) do
    input
    |> split_lines()
    |> transpose_text_lines()
  end

  def transpose_text_lines(lines) do
    cols = lines |> hd() |> String.length()

    for current_col <- (cols - 1)..0//-1, reduce: [] do
      transposed_cols ->
        current = Enum.reduce(lines, [], &[String.at(&1, current_col) | &2])
        [current |> Enum.join() |> String.reverse() | transposed_cols]
    end
  end
end

defmodule AdventOfCode.Utils.Repo do
  def create() do
    Agent.start_link(fn -> %{} end, name: :repo)
  end

  def put([{k, v}]) do
    Agent.update(:repo, fn state -> Map.put(state, k, v) end)
  end

  def get(k) do
    Agent.get(:repo, fn state -> Map.get(state, k) end)
  end
end
