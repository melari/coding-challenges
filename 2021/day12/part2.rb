require 'set'

input = File.read("input.txt")

class Node
  START_NAME = "start"
  END_NAME = "end"
  MAX_REVISITS = 1
  attr_accessor :name, :size, :neighbours
  def initialize(name)
    @name = name
    @size = name.upcase == name ? :big : :small
    @neighbours = Set.new
  end

  def endpoint?
    name == START_NAME || name == END_NAME
  end

  def small?
    size == :small
  end

  def revisit_only_once?
    small? && !endpoint?
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

  def find_paths(from = start_node, to = end_node, visited = [], revisit_happened = false)
    return [[from]] if from == to
    from.neighbours.reduce([]) do |paths, n|
      revisiting_now = false
      if visited.include?(n)
        next paths if n.endpoint?
        next paths if n.revisit_only_once? && revisit_happened
        revisiting_now = true if n.revisit_only_once?
      end
      paths + find_paths(n, to, visited + [from], revisit_happened || revisiting_now).map { |p| [from] + p }
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
final = paths.map { |p| p.map(&:name).join(",") }
pp final
pp paths.count
