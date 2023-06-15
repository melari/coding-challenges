require 'set'

map = File.read("input.txt").split("\n").map { |line| line.split('').map(&:to_i) }

#map = [
#  [5, 4, 3, 0, 1],
#  [8, 3, 2, 9, 9],
#  [9, 4, 9, 2, 1],
#]

# determine map size
minx = miny = 0
maxx = map.first.count - 1
maxy = map.count - 1

# generate empty delta map
map.each_with_index do |row, y|
  row.each_with_index do |element, x|
    map[y][x] = {
      position: [x, y], # looks unused, but makes the element unique in the basin set below.
      value: element,
      uphill: []
    }
  end
end

# generate uphill tree structure
minima = []
map.each_with_index do |row, y|
  row.each_with_index do |element, x|
    neighbours = [
      x == maxx ? nil : map[y][x+1], #right
      y == miny ? nil : map[y-1][x], #up
      x == minx ? nil : map[y][x-1], #left
      y == maxy ? nil : map[y+1][x], #down
    ].compact
    map[y][x][:uphill] = neighbours.map do |n|
      n[:value] > element[:value] ? n : nil
    end.compact
    minima << [x, y] if map[y][x][:uphill].count == neighbours.count && map[y][x][:value] != 9
  end
end

# calculate size of each basin
basin_sizes = minima.map do |min|
  basin = Set.new
  waiting = [map[min.last][min.first]]
  until waiting.empty?
    focus = waiting.shift
    basin << focus
    waiting += focus[:uphill].select { |n| n[:value] != 9 }
  end

  basin.count
end

puts basin_sizes.max(3).reduce(&:*)
