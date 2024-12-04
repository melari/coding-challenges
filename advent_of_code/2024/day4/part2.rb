grid = File.open('input.txt').map { |line| line.strip.chars }
puts((1..grid.length-2).map do |y|
  (1..grid[0].length-2).count do |x|
    grid[y][x] == 'A' &&
    [grid[y-1][x-1], grid[y+1][x+1]].sort == ['M', 'S'] &&
    [grid[y-1][x+1], grid[y+1][x-1]].sort == ['M', 'S']
  end
end.sum)
