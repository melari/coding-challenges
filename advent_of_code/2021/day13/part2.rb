# Parse out points & folds from the input file
points = []
folds = []
File.read("input.txt").split("\n").each do |line|
  if line.start_with?("fold")
    match = /fold along (?<dim>[x|y])=(?<value>[0-9]+)/.match(line)
    folds << [match[:dim], match[:value].to_i]
  elsif line.empty? # pesky empty line in the middle
    next
  else
    points << line.split(',').map(&:to_i)
  end
end

#points = [[1,1],[5,2]]
#folds = [["x", 3]]

# Determine the size of the map based on the given points
minx = miny = 0
maxx = points.map(&:first).max
maxy = points.map(&:last).max

# Initialize map from points
map = Array.new(maxy + 1) { Array.new(maxx + 1, false) }
points.each do |point|
  pp point if map[point.last].nil?
  map[point.last][point.first] = true
end

# Process the first fold
folds.each do |fold|
  maxx = fold.last - 1 if fold.first == "x"
  maxy = fold.last - 1 if fold.first == "y"
  new_map = Array.new(maxy + 1) { Array.new(maxx + 1, false) }
  map.each_with_index do |row, y|
    row.each_with_index do |element, x|
      next if x == maxx + 1 || y == maxy + 1 # fold line is destroyed
      target_x = x > maxx ? 2 * maxx - x + 2 : x
      target_y = y > maxy ? 2 * maxy - y + 2 : y
      new_map[target_y][target_x] ||= element
    end
  end
  map = new_map
end

# Make map human readable
map.each do |row|
  row.each do |e|
    print(e ? "#" : " ")
  end
  print("\n")
end
