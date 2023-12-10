names_to_digits = %{
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9"
}

number_names = Map.keys(names_to_digits)
number_names_reverse = Enum.map(number_names, &String.reverse(&1))

parse_name = fn str -> names_to_digits[str] end
parse_name_reverse = fn str -> names_to_digits[String.reverse(str)] end

sanitize_from_left = fn line ->
  String.replace(line, number_names, parse_name)
  |> String.replace(~r/[[:alpha:]]/, "")
  |> String.at(0)
end

sanitize_from_right = fn line ->
  String.replace(String.reverse(line), number_names_reverse, parse_name_reverse)
  |> String.reverse()
  |> String.replace(~r/[[:alpha:]]/, "")
  |> String.at(-1)
end

sanitize_line = fn line ->
  ([sanitize_from_left.(line)] ++ [sanitize_from_right.(line)])
  |> Enum.join()
  |> String.to_integer()
end

{_status, contents} = File.read("input.txt")

contents
|> String.split()
|> Enum.map(sanitize_line)
|> Enum.sum()
|> IO.puts()
