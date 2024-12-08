map = File.open('input.txt').map { |row| row.chomp.chars }
h = map.length
w = map[0].length

towers_by_kind = map.each_with_object({}).with_index do |(row, acc), y| 
  row.each_with_index { |e, x| (acc[e] ||= []) && acc[e] << [x, y] unless e == '.' }
end

antinodes = towers_by_kind.values.flat_map do |towers|
  towers.permutation(2).map { |a, b| [2*a[0]-b[0], 2*a[1]-b[1]] }
end

antinodes
  .select { |(x, y)| x >= 0 && y >= 0 && x < w && y < h }
  .uniq
  .count
  .tap { |x| p(x) }
