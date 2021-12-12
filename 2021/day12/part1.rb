require 'set'

input = File.read("input.txt")

class Node
  START_NAME = "start"
  END_NAME = "end"
  attr_accessor :name, :size, :neighbours
  def initialize(name)
    @name = name
    @size = name.upcase == name ? :big : :small
    @neighbours = Set.new
  end
end

class Map
  attr_reader :nodes
  def initialize
    @nodes = {}
  end

  def [](name)
    nodes[name] ||= Node.new(name)
    nodes[name]
  end

  def start_node
    nodes[Node::START_NAME]
  end

  def end_node
    nodes[Node::END_NAME]
  end

  def find_paths(from = start_node, to = end_node, visited = [])
    return [[from]] if from == to
    from.neighbours.reduce([]) do |paths, n|
      next paths if n.size == :small && visited.include?(n)
      paths + find_paths(n, to, visited + [from]).map { |p| [from] + p }
    end
  end
end


map = Map.new

connections = input.split("\n").map { |line| line.split("-") }
connections.each do |(a, b)|
  map[a].neighbours << map[b]
  map[b].neighbours << map[a]
end

paths = map.find_paths
pp paths.map { |p| p.map(&:name).join(",") }
pp paths.count
