require_relative '../../../lib/grid.rb'

ROBOT = '@'
EMPTY = '.'
WALL = '#'
BOX = 'O'
BOX_LEFT = '['
BOX_RIGHT = ']'

rawgrid, rawmoves = File.read('input.txt').split("\n\n")
rawgrid.gsub!(EMPTY, "#{EMPTY}#{EMPTY}")
rawgrid.gsub!(WALL, "#{WALL}#{WALL}")
rawgrid.gsub!(ROBOT, "#{ROBOT}#{EMPTY}")
rawgrid.gsub!(BOX, "#{BOX_LEFT}#{BOX_RIGHT}")

grid = Grid.from_str(rawgrid)
robot = Vect2[0,0]
grid.values_with_positions.each do |cell, pos|
  next unless cell == ROBOT
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
  if [Vect2.left, Vect2.right].include?(dir)
    try_shift_box_hor(pos, dir, grid)
  else
    try_shift_box_vert(pos, dir, grid)
  end
end

def try_shift_box_hor(pos, dir, grid)
  other_box_pos = pos + dir
  other_box = grid[other_box_pos]
  this_box = grid[pos]

  beside_pos = other_box_pos + dir
  beside = grid[beside_pos]

  case beside
  when WALL
    false
  when EMPTY
    grid[beside_pos] = other_box
    grid[other_box_pos] = this_box
    grid[pos] = EMPTY
    true
  when BOX_LEFT, BOX_RIGHT
    if try_shift_box_hor(beside_pos, dir, grid)
      grid[beside_pos] = other_box
      grid[other_box_pos] = this_box
      grid[pos] = EMPTY
      true
    else
      false
    end
  end
end

def try_shift_box_vert(pos, dir, grid, execute: true)
  this_box = grid[pos]
  other_box_pos = this_box == BOX_LEFT ? pos + Vect2.right : pos + Vect2.left
  other_box = grid[other_box_pos]

  beside_positions = [pos + dir, other_box_pos + dir]

  return false if beside_positions.any? do |bp|
    next false if grid[bp] == EMPTY
    next true if grid[bp] == WALL
    !try_shift_box_vert(bp, dir, grid, execute: false)
  end

  return true unless execute

  beside_positions.each do |bp|
    try_shift_box_vert(bp, dir, grid) if [BOX_LEFT, BOX_RIGHT].include?(grid[bp])
  end
  grid[pos+dir] = this_box
  grid[other_box_pos+dir] = other_box
  grid[pos] = EMPTY
  grid[other_box_pos] = EMPTY

  true
end

moves.each do |dir|
  beside_pos = robot + dir
  beside = grid[beside_pos]
  next if beside == WALL
  robot = beside_pos if beside == EMPTY || try_shift_box(beside_pos, dir, grid)
end


gps = grid.values_with_positions.sum do |cell, pos|
  next 0 unless cell == BOX_LEFT
  100*pos.y + pos.x
end

puts gps
