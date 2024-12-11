require_relative '../../../lib/grid.rb'
grid = Grid.from_file('input.txt')

WORD = "XMAS"

def gen_word(pos, direction, grid)
  (0...WORD.length).map { |offset| grid[pos + offset * direction] }.join
end

def gen_words(pos, grid)
  l = WORD.length

  search_right = pos.x <= grid.w - l
  search_left  = pos.x >= l - 1
  search_down  = pos.y <= grid.h - l
  search_up    = pos.y >= l - 1

  words = []
  words << gen_word(pos, Vect2.right, grid)     if search_right
  words << gen_word(pos, Vect2.left, grid)      if search_left
  words << gen_word(pos, Vect2.down, grid)      if search_down
  words << gen_word(pos, Vect2.up, grid)        if search_up
  words << gen_word(pos, Vect2.downright, grid) if search_right && search_down
  words << gen_word(pos, Vect2.upright, grid)   if search_right && search_up
  words << gen_word(pos, Vect2.downleft, grid)  if search_left && search_down
  words << gen_word(pos, Vect2.upleft, grid)    if search_left && search_up
  words
end

count = 0
grid.values_with_positions.each do |_value, pos|
  count += gen_words(pos, grid).count { |word| word == WORD }
end

puts count
