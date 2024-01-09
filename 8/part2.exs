defmodule Graph do
  def add(graph, node, left, right) do
    Map.put_new(graph, node, %{L: left, R: right})
  end

  def go(graph, :L, node) do
    Map.get(graph, node)."L"
  end

  def go(graph, :R, node) do
    Map.get(graph, node)."R"
  end

  def filter(graph, regex) do
    for {node, directions} <- graph, node =~ regex do
      {node, directions}
    end
  end
end

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

  def parse_line(line) do
    [origin, raw_nodes] = String.split(line, " = ")

    [left, right] =
      raw_nodes
      |> String.replace(~r/\(|\)/, "")
      |> String.split(", ")

    {origin, {left, right}}
  end

  def walk(graph, navigation, step_count) do
    %{
      steps: steps,
      original_steps: original_steps,
      current_node: current_node,
      target_pattern: target_pattern
    } = navigation

    cond do
      Regex.match?(target_pattern, current_node) ->
        step_count

      steps === [] ->
        [current_step | remaining_steps] = original_steps
        next_node = Graph.go(graph, current_step, current_node)

        updated_navigation = %{
          steps: remaining_steps,
          original_steps: original_steps,
          current_node: next_node,
          target_pattern: target_pattern
        }

        walk(graph, updated_navigation, step_count + 1)

      true ->
        [current_step | remaining_steps] = steps
        next_node = Graph.go(graph, current_step, current_node)

        updated_navigation = %{
          steps: remaining_steps,
          original_steps: original_steps,
          current_node: next_node,
          target_pattern: target_pattern
        }

        walk(graph, updated_navigation, step_count + 1)
    end
  end

  def test_for_factors(subject) do
    check_limit = subject ** 0.5

    test_for_factors(subject, 2, check_limit)
  end

  def test_for_factors(subject, _, _) when subject < 4 do
    true
  end

  def test_for_factors(subject, test, check_limit) when test < check_limit do
    if rem(subject, test) !== 0 do
      test_for_factors(subject, test + 1, check_limit)
    else
      false
    end
  end

  def test_for_factors(subject, test, _) do
    rem(subject, test) !== 0
  end

  def primes_up_to(max) do
    Enum.filter(2..max, &test_for_factors/1)
  end

  def lcm(numbers) do
    primes = primes_up_to(Enum.max(numbers))

    lcm({numbers, numbers}, primes, [])
  end

  def lcm({iteration, original_numbers}, [final_prime | []], factors) do
    is_divisible = fn val ->
      if rem(val, final_prime) === 0, do: :divisible, else: :indivisible
    end

    %{:divisible => divisibles, :indivisible => indivisibles} =
      iteration |> Enum.group_by(is_divisible)

    if divisibles !== [] do
      division_results = divisibles |> Enum.map(&div(&1, final_prime))

      lcm({[division_results | indivisibles], original_numbers}, [final_prime], [
        final_prime | factors
      ])
    else
      Enum.product(factors)
    end
  end

  def lcm({iteration, original_numbers}, [current_prime | remaining_primes], factors) do
    is_divisible = fn val ->
      if rem(val, current_prime) === 0, do: :divisible, else: :indivisible
    end

    %{:divisible => divisibles, :indivisible => indivisibles} =
      iteration |> Enum.group_by(is_divisible)

    if divisibles !== [] do
      division_results = divisibles |> Enum.map(&div(&1, current_prime))

      lcm(
        {[division_results | indivisibles], original_numbers},
        [current_prime | remaining_primes],
        [
          current_prime | factors
        ]
      )
    else
      lcm({original_numbers, original_numbers}, remaining_primes, factors)
    end
  end
end

{_, contents} = File.read("test2.txt")

[raw_directions, _ | raw_node_list] =
  contents
  |> String.split("\n")

directions =
  raw_directions
  |> String.split("", trim: true)
  |> Enum.map(&String.to_atom/1)

nodes = Enum.map(raw_node_list, &Solution.parse_line/1)

graph =
  for {node, {left, right}} <- nodes, reduce: %{} do
    graph -> Graph.add(graph, node, left, right)
  end

ends_with_a = ~r/[A-Z0-9]{2}A/
ends_with_z = ~r/[A-Z0-9]{2}Z/

starting_nodes = Graph.filter(graph, ends_with_a)

Solution.pretty_print(starting_nodes)

steps_to_z =
  for {node, _} <- starting_nodes do
    navigation = %{
      steps: directions,
      original_steps: directions,
      current_node: node,
      target_pattern: ends_with_z
    }

    Solution.walk(graph, navigation, 0)
  end

Solution.pretty_print(steps_to_z)
Solution.pretty_print(Solution.lcm(steps_to_z))
