{_status, contents} = File.read("input.txt")

parse_line = fn line ->
  String.at(line, 0) <> String.at(line, -1)
  |> String.to_integer
end

contents
|> String.replace(~r/[[:alpha:]]/, "")
|> String.split("\r\n")
|> Enum.map(parse_line)
|> Enum.sum
|> IO.puts
