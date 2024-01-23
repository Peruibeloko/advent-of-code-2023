defmodule AdventOfCode.Day8.Graph do
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
    for {node, directions} <- graph, node =~ regex do
      {node, directions}
    end
  end
end
