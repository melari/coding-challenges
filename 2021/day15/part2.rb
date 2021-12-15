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
    !@map[n[1]][n[0]][:visited]
  end
end

def visit(step)
  @map[step[:pos][1]][step[:pos][0]][:visited] = true
  @map[step[:pos][1]][step[:pos][0]][:candidates].each do |obsolete_candidate|
    next if obsolete_candidate == step # the selected step is already removed by the selection `shift`
    candidates_delete(obsolete_candidate)
  end
  @map[step[:pos][1]][step[:pos][0]][:candidates] = []

  unvisited_neighbours_of(step[:pos]).each do |new_candidate_pos|
    new_candidate = build_step(new_candidate_pos, step)
    candidates_insert(new_candidate)
  end
end

# Edge steps are kept sorted by weight to make each main loop iteration O(logn) instead of O(n)
def candidates_insert(step)
  index = (0...@candidates.size).bsearch { |i| @candidates[i][:total_weight] >= step[:total_weight] }
  if index.nil? # nil means the weight is greater than all others in the array (including empty array)
    @candidates << step
  else
    @candidates.insert(index, step)
  end
  @map[step[:pos][1]][step[:pos][0]][:candidates] << step
end

# O(logn) deletion
def candidates_delete(step)
  index = (0...@candidates.size).bsearch { |i| @candidates[i][:total_weight] >= step[:total_weight] }
  loop do
    raise 'did not find' if index >= @candidates.size
    if @candidates[index] == step
      @candidates.delete_at(index)
      break
    end
    index += 1
  end
end

first_tile = File.read("input.txt").split("\n").map { |line| line.split('').map(&:to_i) }

@weights = []
(0..4).each do |y_increase|
  first_tile.each do |row|
    full_row = []
    (0..4).each do |x_increase|
      row.each do |value|
        full_row << (value + x_increase + y_increase - 1) % 9 + 1
      end
    end
    @weights << full_row
  end
end

@minx = @miny = 0
@maxx = @weights.first.count - 1
@maxy = @weights.count - 1

@map = Array.new(@maxy + 1) { Array.new(@maxx + 1) { { visited: false, candidates: [] } } }
@candidates = []

# goal is bottom right
goal = [@maxx, @maxy]

# starting position is top-left (0,0)
visit(build_step([@minx, @miny], nil))

winner = nil
loop do
  next_step = @candidates.shift

  pp next_step[:pos] if rand < 0.05

  visit(next_step)
  if next_step[:pos] == goal
    winner = next_step
    break
  end
end

pp winner[:total_weight]
