def find_peaks_from(location, map)
  height = map[location[1]][location[0]]
  return [location] if height == 9 # base case: we are already at the peak

  neighbours = []
  neighbours << [location[0]+1, location[1]] if location[0] < map[0].length - 1
  neighbours << [location[0], location[1]+1] if location[1] < map.length - 1
  neighbours << [location[0]-1, location[1]] if location[0] > 0
  neighbours << [location[0], location[1]-1] if location[1] > 0

  neighbours.flat_map { |n| find_peaks_from(n, map) if map[n[1]][n[0]] == height + 1 }.compact
end

map = File.open('input.txt').map { |line| line.chomp.chars.map(&:to_i) }
trailheads = map.each_with_index.flat_map { |row, y| row.each_with_index.map { |e, x| [x,y] if e == 0 } }.compact

# part1
puts trailheads.sum { |trailhead| find_peaks_from(trailhead, map).uniq.length }

# part 2
puts trailheads.sum { |trailhead| find_peaks_from(trailhead, map).length }
