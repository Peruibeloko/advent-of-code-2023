defmodule Digraph do
  def go(direction, vertex, graph) do
    parse_edges = fn [e1, e2] ->
      {_, _, _, direction} = :digraph.edge(graph, e1)

      if direction === "left" do
        {:digraph.edge(graph, e1), :digraph.edge(graph, e2)}
      else
        {:digraph.edge(graph, e2), :digraph.edge(graph, e1)}
      end
    end

    {left, right} =
      graph
      |> :digraph.out_edges(vertex)
      |> parse_edges.()

    if direction === :L, do: left, else: right
  end

  def build_graph(nodes) do
    graph = :digraph.new()

    for {label, {left, right}} <- nodes do
      :digraph.add_vertex(graph, label)
      :digraph.add_vertex(graph, left)
      :digraph.add_vertex(graph, right)
      :digraph.add_edge(graph, label, left, "left")
      :digraph.add_edge(graph, label, right, "right")
    end

    graph
  end
end

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
end

{_, contents} = File.read("input.txt")

[raw_directions, _ | raw_node_list] =
  contents
  |> String.split("\r\n")

directions =
  raw_directions
  |> String.split("", trim: true)
  |> Enum.map(&String.to_atom/1)

nodes = Enum.map(raw_node_list, &Solution.parse_line/1)

graph =
  for {node, {left, right}} <- nodes, reduce: %{} do
    graph -> Graph.add(graph, node, left, right)
  end

Solution.pretty_print("Walk input", {directions, graph})

steps = Solution.walk(graph, directions, "AAA", 0, directions)

Solution.pretty_print("Reached ZZZ in", steps)
