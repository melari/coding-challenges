require_relative '../../../lib/grid.rb'

grid = Grid.from_file('input.txt')
grid
  .values_with_positions
  .count do |value, pos|
    pos.in_bounds?(minx: 1, miny: 1, maxx: grid.w-2, maxy: grid.h-2) &&
      grid[pos] == 'A' &&
      [grid[pos + Vect2.upleft], grid[pos + Vect2.downright]].sort == ['M', 'S'] &&
      [grid[pos + Vect2.upright], grid[pos + Vect2.downleft]].sort == ['M', 'S']
  end
  .tap { |r| p(r) }

