require_relative '../../../lib/vector.rb'

def find_peaks_from(location, map)
  return [location] if map[location] == 9 # base case: we are already at the peak
  location
    .bounded_neighbours(map.dim)
    .flat_map { |n| find_peaks_from(n, map) if map[n] == map[location] + 1 }
    .compact
end

map = File.open('input.txt').map { |line| line.chomp.chars.map(&:to_i) }
trailheads = map.each_with_index.flat_map { |row, y| row.each_with_index.map { |e, x| Vect2[x,y] if e == 0 } }.compact

# part1
puts trailheads.sum { |trailhead| find_peaks_from(trailhead, map).uniq.length }

# part 2
puts trailheads.sum { |trailhead| find_peaks_from(trailhead, map).length }
