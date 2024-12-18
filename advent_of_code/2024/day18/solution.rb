require_relative '../../../lib/grid.rb'
require_relative '../../../lib/colorize.rb'
require_relative '../../../lib/pq.rb'

bytes = File.open('input.txt').map { |l| l.split(',') }.map { |x,y| Vect2[x.to_i,y.to_i] }

def pathfind(walls)
  grid = Grid.init_by_position(dim: Vect2[71,71]) { |pos| walls.include?(pos) }

  target = grid.dim + Vect2.upleft
  queue = PQ.increasing { |path| path.length + path.last.manhattan(target) }
  queue << [Vect2.zero]

  while queue.any?
    path = queue.pop
    grid.neighbours(path.last).each do |pos, cell|
      next if cell
      new_path = path + [pos]
      return new_path if pos == target
      grid[pos] = true
      queue << new_path
    end
  end
end

# part 1
puts pathfind(bytes.first(1024)).length - 1

# part 2
first = (0..bytes.length).to_a.bsearch_index { |n| !pathfind(bytes.first(n)) }
puts bytes[first-1].inspect
