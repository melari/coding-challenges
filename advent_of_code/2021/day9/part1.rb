map = File.read("input.txt").split("\n").map { |line| line.split('').map(&:to_i) }

#map = [
#  [5, 4, 3, 0, 1],
#  [8, 3, 2, 1, 2],
#  [9, 4, 5, 2, 1],
#]

# determine map size
minx = miny = 0
maxx = map.first.count - 1
maxy = map.count - 1

# generate delta map
map.each_with_index do |row, y|
  row.each_with_index do |element, x|
    map[y][x] = {
      value: element,
      deltas: [
        x == maxx ? nil : (map[y][x + 1] - element), # right
        y == miny ? nil : (map[y - 1][x][:value] - element), # up
        x == minx ? nil : (map[y][x - 1][:value] - element), # left
        y == maxy ? nil : (map[y + 1][x] - element), # down
      ]
    }
  end
end

# find local minima
minima = map.flat_map do |row|
  row.map do |element|
    element[:deltas].compact.all? { |d| d.positive? } ? element[:value] : nil
  end.compact
end

puts minima.map { |m| m+1 }.sum
