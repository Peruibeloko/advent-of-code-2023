alias AdventOfCode.Utils
alias AdventOfCode.Day8.Graph

defmodule AdventOfCode.Day8.Part2 do
  def walk(graph, navigation, step_count) do
    %{
      steps: steps,
      original_steps: original_steps,
      current_node: current_node,
      target_pattern: target_pattern
    } = navigation

    [current_step | remaining_steps] =
      if steps === [] do
        original_steps
      else
        steps
      end

    if Regex.match?(target_pattern, current_node) do
      step_count
    else
      next_node = Graph.go(current_step, current_node, graph)

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

  def lcm({iteration, original_numbers}, [current_prime | remaining_primes], factors) do
    is_divisible = fn
      val, div when rem(val, div) === 0 -> "divisible"
      _, _ -> "indivisible"
    end

    to_array = fn
      nil -> []
      val -> val
    end

    grouped_numbers =
      iteration
      |> Enum.group_by(&is_divisible.(&1, current_prime))

    divisibles = to_array.(grouped_numbers["divisible"])
    indivisibles = to_array.(grouped_numbers["indivisible"])

    cond do
      divisibles !== [] ->
        division_results = divisibles |> Enum.map(&div(&1, current_prime))

        lcm(
          {division_results ++ indivisibles, original_numbers},
          [current_prime | remaining_primes],
          [
            current_prime | factors
          ]
        )

      remaining_primes === [] ->
        Enum.product(factors)

      true ->
        lcm({original_numbers, original_numbers}, remaining_primes, factors)
    end
  end

  def parse_line(line) do
    [origin, raw_nodes] = String.split(line, " = ")

    [left, right] =
      raw_nodes
      |> String.replace(~r/\(|\)/, "")
      |> String.split(", ")

    {origin, {left, right}}
  end

  def parse_file(file_name) do
    {_, contents} = File.read(file_name)

    [raw_directions, _ | raw_node_list] =
      contents
      |> String.split(["\n", "\r\n"])

    directions =
      raw_directions
      |> String.split("", trim: true)
      |> Enum.map(&String.to_atom/1)

    nodes = Enum.map(raw_node_list, &parse_line/1)

    {nodes, directions}
  end

  def init_graph(nodes) do
    for {node, {left, right}} <- nodes, reduce: %{} do
      graph -> Graph.add(graph, node, left, right)
    end
  end

  def run(file_name) do
    ends_with_a = ~r/[A-Z0-9]{2}A/
    ends_with_z = ~r/[A-Z0-9]{2}Z/

    {nodes, directions} = parse_file(file_name)

    graph = init_graph(nodes)

    starting_nodes = Graph.filter(graph, ends_with_a)

    Utils.pretty_print(starting_nodes)

    steps_to_z =
      for {node, _} <- starting_nodes do
        navigation = %{
          steps: directions,
          original_steps: directions,
          current_node: node,
          target_pattern: ends_with_z
        }

        walk(graph, navigation, 0)
      end

    Utils.pretty_print(steps_to_z)
    Utils.pretty_print(lcm(steps_to_z))
  end
end
