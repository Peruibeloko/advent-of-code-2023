alias AdventOfCode.Utils
alias AdventOfCode.Day8.Graph

defmodule AdventOfCode.Day8.Part1 do
  def walk(graph, [current_step | remaining_steps], node, step_count, original_steps) do
    # pretty_print("Walking", {current_step, node, step_count})
    result = Graph.go(current_step, node, graph)
    walk(graph, remaining_steps, result, step_count + 1, original_steps)
  end

  def walk(_, _, "ZZZ", step_count, _) do
    step_count
  end

  def walk(graph, [], node, step_count, original_steps) do
    [current_step | remaining_steps] = original_steps
    # pretty_print("Restart steps", {current_step, node, step_count})
    result = Graph.go(current_step, node, graph)
    walk(graph, remaining_steps, result, step_count + 1, original_steps)
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
      String.split(contents, ["\n", "\r\n"])

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
    {nodes, directions} = parse_file(file_name)

    graph = init_graph(nodes)

    Utils.pretty_print("Walk input", {directions, graph})

    steps = walk(graph, directions, "AAA", 0, directions)

    Utils.pretty_print("Reached ZZZ in", steps)
  end
end
