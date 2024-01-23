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

  def parse_file(file_path, line_parser) do
    {_, contents} = File.read(file_path)

    contents
    |> String.split(["\n", "\r\n"])
    |> Enum.map(line_parser)
  end
end
