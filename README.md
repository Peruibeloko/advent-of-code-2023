# Advent of Code 2023 (Elixir)

This repo contains my solutions for the 2023 Advent of Code. I took this opportunity to learn a new language I've been wanting to try out for some time, [Elixir](https://elixir-lang.org/), a widely used Brazilian functional programming language.

What you'll find in here is mostly comprised of DSA, text manipulation and some other shenanigans.

## Running

To run this project:

1. Install [Erlang/OTP 25 (direct link)](https://github.com/erlang/otp/releases/download/OTP-25.3.2.8/otp_win64_25.3.2.8.exe)
1. Install [Elixir (direct link)](https://github.com/elixir-lang/elixir/releases/download/v1.16.0/elixir-otp-25.exe)
1. Clone this repo
1. Run the `day` [task](#tasks)

## Tasks

### `mix day <day>.<part> [filename]`

This command allows you to run the solution for the specific day and part, possibly using the provided filename as input.

If filename is absent, uses `input.txt`

Examples:

```bash
# Runs solution for Day 3 Part 2, using input.txt
mix day 3.2

# Runs solution for Day 4 Part 1, using test.txt
mix day 4.1 test
```

### `mix create <day>`

Generates the following boilerplate for solving `day`:

```
advent_of_code/
├── (other solutions)
└── day_n/
    ├── part_1.ex
    ├── part_2.ex
    ├── input.txt
    └── test.txt
```

Each solution part is also initialized with some boilerplate code:

```elixir
alias AdventOfCode.Utils

defmodule AdventOfCode.Day$day_number$.Part$part_number$ do
  def line_parser(line) do
    line
  end

  def run(file_name) do
    file_name
    |> Utils.parse_file(&line_parser/1)
  end
end
```

The `$day_number$` and `$part_number$` placeholders are replaced with the proper values during creation.
