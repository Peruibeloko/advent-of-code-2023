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

  def parse_file(file_contents) do
    parse_line = fn line ->

    end

    file_contents
    |> String.split("\n")
    |> Enum.map(parse_line)
  end
end

{_, contents} = File.read("input.txt")

Solution.parse_file(contents)
|> IO.inspect()
