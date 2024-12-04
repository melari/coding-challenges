grid = File.open('input.txt').map { |line| line.strip.chars }

WORD = "XMAS"

def gen_word(x, y, dx, dy, grid)
  (0...WORD.length).map { |offset| grid[y+offset*dy][x+offset*dx] }.join
end

def gen_words(x, y, grid)
  w = grid[0].length
  h = grid.length
  l = WORD.length

  search_right = x <= w - l
  search_left  = x >= l - 1
  search_down  = y <= h - l
  search_up    = y >= l - 1

  words = []
  words << gen_word(x, y, 1, 0, grid)   if search_right
  words << gen_word(x, y, -1, 0, grid)  if search_left
  words << gen_word(x, y, 0, 1, grid)   if search_down
  words << gen_word(x, y, 0, -1, grid)  if search_up
  words << gen_word(x, y, 1, 1, grid)   if search_right && search_down
  words << gen_word(x, y, 1, -1, grid)  if search_right && search_up
  words << gen_word(x, y, -1, 1, grid)  if search_left && search_down
  words << gen_word(x, y, -1, -1, grid) if search_left && search_up
  words
end

count = 0
grid.each_with_index do |row, y|
  row.each_with_index do |_c, x|
    count += gen_words(x, y, grid).count { |word| word == WORD }
  end
end

puts count
