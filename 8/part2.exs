defmodule Graph do
  def add(graph, node, left, right) do
    Map.put_new(graph, node, %{L: left, R: right})
  end

  def go(:L, node, graph) do
    Map.get(graph, node)."L"
  end

  def go(:R, node, graph) do
    Map.get(graph, node)."R"
  end

  def filter(graph, regex) do
    graph
    |> Enum.filter(&(Regex.run(regex, elem(&1, 0)) !== nil))
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

  def walk(graph, [current_step | remaining_steps], node, step_count, original_steps, target) do
    pretty_print({target, node})
    if Regex.match?(target, node) do
      step_count
    else
      result = Graph.go(current_step, node, graph)
      walk(graph, remaining_steps, result, step_count + 1, original_steps, target)
    end
  end

  def walk(graph, [], node, step_count, original_steps, target) do
    if Regex.match?(target, node) do
      step_count
    else
      [current_step | remaining_steps] = original_steps
      result = Graph.go(current_step, node, graph)
      walk(graph, remaining_steps, result, step_count + 1, original_steps, target)
    end
  end
end

{_, contents} = File.read("input.txt")

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

starting_nodes = Graph.filter(graph, ~r/[A-Z]{2}A/)
ending_nodes = Graph.filter(graph, ~r/[A-Z]{2}Z/)

Solution.pretty_print(starting_nodes)
Solution.pretty_print(ending_nodes)

steps_to_z =
  for {node, _} <- ending_nodes do
    Solution.walk(graph, directions, node, 0, directions, ~r/[A-Z]{2}A/)
  end

# steps_to_a =
#   for {node, _} <- ending_nodes do
#     Solution.walk(graph, directions, node, 0, directions, ~r/[A-Z]{2}A/)
#   end

Solution.pretty_print(steps_to_z)
# Solution.pretty_print(steps_to_a)
