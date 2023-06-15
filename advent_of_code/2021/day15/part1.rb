def build_step(pos, parent)
  {
    pos: pos,
    parent: parent,
    total_weight: parent.nil? ? 0 : parent[:total_weight] + @weights[pos[1]][pos[0]]
  }
end

def unvisited_neighbours_of(pos)
  [
    [pos[0]-1, pos[1]],
    [pos[0]+1, pos[1]],
    [pos[0], pos[1]-1],
    [pos[0], pos[1]+1],
  ].filter do |n|
    n[0] >= @minx &&
    n[0] <= @maxx &&
    n[1] >= @miny &&
    n[1] <= @maxy &&
    !@visited[n[1]][n[0]]
  end
end

def visit(step)
  @edge_steps << step
  @visited[step[:pos][1]][step[:pos][0]] = true

  @edge_steps.delete(step[:parent]) if step[:parent] && unvisited_neighbours_of(step[:parent][:pos]).empty?
end

@weights = File.read("input.txt").split("\n").map { |line| line.split('').map(&:to_i) }

#@weights = [
#  [1, 2, 3, 2, 3],
#  [1, 2, 3, 2, 3],
#  [3, 1, 2, 1, 2],
#  [1, 4, 3, 2, 1],
#  [1, 1, 1, 1, 2],
#]

@minx = @miny = 0
@maxx = @weights.first.count - 1
@maxy = @weights.count - 1
@visited = Array.new(@maxy + 1) { Array.new(@maxx + 1, false) }
@edge_steps = []

# goal is bottom right
goal = [@maxx, @maxy]

# starting position is top-left (0,0)
visit(build_step([@minx, @miny], nil))

loop do
  next_step = @edge_steps.flat_map do |leaf|
    unvisited_neighbours_of(leaf[:pos]).map do |neighbour_pos|
      build_step(neighbour_pos, leaf)
    end
  end.min_by { |p| p[:total_weight] }

  pp next_step[:pos] if rand < 0.05

  visit(next_step)
  break if next_step[:pos] == goal
end

winner = @edge_steps.last
pp winner[:total_weight]
