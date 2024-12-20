require_relative '../../../lib/grid.rb'

map = Grid.from_file('input.txt')
@scores = map.dup.map { nil }

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
    @scores.zone(pos, shortcut_time).count do |_, n_score, n_dist|
      next false if n_score.nil?
      @scores[pos] - n_score - n_dist >= 100
    end
  end
end

# part 1
puts shortcuts(2)

# part 2
puts shortcuts(20)
