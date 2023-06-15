map = Array.new(1000) { Array.new(1000, 0) }
File.read("input.txt").split("\n").each do |line|
  start, finish = line.split(" -> ").map { |pair| pair.split(',').map(&:to_i) }
  dir = [finish[0] <=> start[0], finish[1] <=> start[1]]
  next if dir[0] != 0 && dir[1] != 0 # skip diagonals for part 1
  pos = start.dup
  map[pos[1]][pos[0]] += 1
  while pos != finish
    pos[0] += dir[0]
    pos[1] += dir[1]
    map[pos[1]][pos[0]] += 1
  end
end

puts map.sum { |row| row.sum { |x| x > 1 ? 1 : 0 } }
