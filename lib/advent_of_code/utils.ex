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
    {_, contents} = File.read(file_path)
    contents
  end

  def split_lines(string) do
    String.split(string, ["\n", "\r\n"])
  end

  def get_lines(file_path) do
    file_path
    |> read_file()
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
end
