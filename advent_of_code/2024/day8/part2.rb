map = File.open('input.txt').map { |row| row.chomp.chars }
H = map.length
W = map[0].length

def antinodes(start, dir)
  result = []
  pos = start
  while pos[0] >= 0 && pos[1] >= 0 && pos[0] < W && pos[1] < H
    result << pos
    pos = [pos[0]+dir[0], pos[1]+dir[1]]
  end
  result
end

towers_by_kind = map.each_with_object({}).with_index do |(row, acc), y| 
  row.each_with_index { |e, x| (acc[e] ||= []) && acc[e] << [x, y] unless e == '.' }
end

towers_by_kind
  .values
  .flat_map { |towers| towers.permutation(2).to_a } # List of lines (two points)
  .map { |(a, b)| [a, [a[0]-b[0], a[1]-b[1]]] }     # List of rays: (start point + direction)
  .flat_map { |start, dir| antinodes(start, dir) }  # List of antinodes (single point)
  .uniq
  .count
  .tap { |x| p(x) }
