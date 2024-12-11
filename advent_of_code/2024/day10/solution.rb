require_relative '../../../lib/grid.rb'

def find_peaks_from(location, map)
  return [location] if map[location] == 9 # base case: we are already at the peak
  location
    .bounded_neighbours(map.dim)
    .flat_map { |n| find_peaks_from(n, map) if map[n] == map[location] + 1 }
    .compact
end

map = Grid.from_file('input.txt').map(&:to_i)
trailheads = map.values_with_positions.select { |value, pos| value == 0 }.map(&:last)

# part1
puts trailheads.sum { |trailhead| find_peaks_from(trailhead, map).uniq.length }

# part 2
puts trailheads.sum { |trailhead| find_peaks_from(trailhead, map).length }
