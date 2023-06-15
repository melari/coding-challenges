map = File.read("input.txt").split("\n").map { |line| line.split('').map(&:to_i) }
next_state = map.dup

@minx = @miny = 0
@maxx = map.first.count - 1
@maxy = map.count - 1

def increment(next_state, x, y)
  return if next_state[y][x] == -1 # dont increment if already flashed this round

  next_state[y][x] = next_state[y][x] + 1
  if next_state[y][x] > 9
    @total_flashes += 1
    next_state[y][x] = -1 # signals a flash was completed, dont receive any new energy this round
    [
      x > @minx ? [x-1,y] : nil,
      x < @maxx ? [x+1,y] : nil,
      y > @miny ? [x,y-1] : nil,
      y < @maxy ? [x,y+1] : nil,
      x > @minx && y > @miny ? [x-1,y-1] : nil,
      x < @maxx && y < @maxy ? [x+1,y+1] : nil,
      x < @maxx && y > @miny ? [x+1,y-1] : nil,
      x > @minx && y < @maxy ? [x-1,y+1] : nil,
    ].compact.each do |neighbour|
      increment(next_state, *neighbour)
    end
  end
end

@total_flashes = 0

100.times do |i|
  puts "Turn #{i}"
  pp next_state
  puts "_____________________________________"
  next_state.each_with_index do |row, y|
    row.each_with_index do |element, x|
      increment(next_state, x, y)
    end
  end

  next_state.each_with_index do |row, y|
    row.each_with_index do |element, x|
      next_state[y][x] = 0 if next_state[y][x] == -1
    end
  end
end

pp next_state
puts @total_flashes
