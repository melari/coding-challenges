require_relative '../../../lib/grid.rb'

EMPTY = '.'
WALL = '#'
BOX = 'O'

rawgrid, rawmoves = File.read('input.txt').split("\n\n")
grid = Grid.from_str(rawgrid)
robot = Vect2[0,0]
grid.values_with_positions.each do |cell, pos|
  next unless cell == '@'
  robot = pos
  grid[pos] = '.'
end
moves = rawmoves.chars.map do |move|
  case move
    when '<' then Vect2.left
    when '>' then Vect2.right
    when '^' then Vect2.up
    when 'v' then Vect2.down
    else nil
  end
end.compact
# == input parsing end

def try_shift_box(pos, dir, grid)
  beside_pos = pos + dir
  beside = grid[beside_pos]
  case beside
  when WALL
    false
  when EMPTY
    grid[beside_pos] = BOX
    grid[pos] = EMPTY
    true
  when BOX
    if try_shift_box(beside_pos, dir, grid)
      grid[beside_pos] = BOX
      grid[pos] = EMPTY
      true
    else
      false
    end
  end
end

moves.each do |dir|
  beside_pos = robot + dir
  beside = grid[beside_pos]
  next if beside == WALL
  robot = beside_pos if beside == EMPTY || try_shift_box(beside_pos, dir, grid)
end

gps = grid.values_with_positions.sum do |cell, pos|
  next 0 unless cell == BOX
  100*pos.y + pos.x
end

puts gps
