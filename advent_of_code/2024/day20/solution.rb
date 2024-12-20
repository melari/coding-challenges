require_relative '../../../lib/grid.rb'

map = Grid.from_file('input.txt')
@scores = Grid.init_by_position(dim: map.dim) { nil }

scan = map.find_pos { |cell| cell == 'E' }
@scores[scan] = 0
@path = [scan]

dist = 0
while map[scan] != 'S'
  scan = map.neighbours(scan).find { |pos, value| @scores[pos] == nil && value != '#' }.first
  @path << scan
  dist += 1
  @scores[scan] = dist
end

def shortcuts(shortcut_time)
  @path.sum do |pos|
    start_score = @scores[pos]
    @scores.zone(pos, shortcut_time).count do |_, n_score, n_dist|
      next false if n_score.nil?
      start_score - n_score - n_dist >= 100
    end
  end
end

# part 1
puts shortcuts(2)

# part 2
puts shortcuts(20)
