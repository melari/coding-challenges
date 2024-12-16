require_relative '../../../lib/grid.rb'

START_TILE = 'S'
END_TILE = 'E'
WALL = '#'
EMPTY = '.'

# best score is directional. "the best score when arriving at the cell facing this way"
grid = Grid.from_file('input.txt').map do |cell|
  {
    type: cell,
    best_scores: { Vect2.up => nil, Vect2.down => nil, Vect2.left => nil, Vect2.right => nil }
  }
end
start_pos = grid.find_pos { |cell| cell[:type] == START_TILE }
start_dir = Vect2.right

candidates = []
queue = [
  { path: [start_pos], total_score: 0 }
]

while queue.any?
  state = queue.shift
  current_pos = state[:path].last
  current_dir = state[:path].length > 1 ? state[:path].last - state[:path][-2] : start_dir

  if grid[current_pos][:type] == END_TILE
    candidates << state
    next
  end

  grid.neighbours(current_pos).each do |next_pos, next_cell|
    next if next_cell[:type] == WALL
    next if state[:path].include?(next_pos)

    movement_dir = next_pos - current_pos
    new_total_score = movement_dir == current_dir ? state[:total_score] + 1 : state[:total_score] + 1001
    next if next_cell[:best_scores][movement_dir] && next_cell[:best_scores][movement_dir] < new_total_score

    next_cell[:best_scores][movement_dir] = new_total_score

    new_state = { path: state[:path] + [next_pos], total_score: new_total_score }
    i = queue.bsearch_index { |x| x[:total_score] >= new_total_score }
    if i.nil?
      queue << new_state
    else
      queue.insert(i, new_state)
    end
  end
end

min_score = candidates.map { |x| x[:total_score] }.min
best_paths = candidates.select { |x| x[:total_score] == min_score }

# part 1
puts best_paths.first[:total_score]

# part 2
puts best_paths.flat_map { |x| x[:path] }.uniq.count
