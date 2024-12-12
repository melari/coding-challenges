require_relative '../../../lib/grid.rb'

grid = Grid.from_file('input.txt').map { |crop| { crop: crop, plot: nil } }

# Stage 1: Identify plots
# Uses a recursive DFS to assign a plot ID to every location in the grid
def assign_plot_id(cell, pos, grid, plot)
  return if cell[:plot] # Dont do anything if this cell already has a plot.

  cell[:plot] = plot

  # visit every neighbour that has a matching crop
  grid.neighbours(pos)
    .select { |_, n_cell| n_cell[:crop] == cell[:crop] }
    .each { |n_pos, n_cell| assign_plot_id(n_cell, n_pos, grid, plot) }
end

next_plot_id = 0
grid.values_with_positions.each do |cell, pos|
  assign_plot_id(cell, pos, grid, next_plot_id += 1)
end


# Stage 2: Identify walls and areas
# Each wall has two attributes: last_saw_at and dir.
#   last_saw_at is the cell where we most recently saw this wall
#   dir represents the "side" the wall is on (ie dir=Vect2.left means I'll hit this wall if I walk left)
walls_by_plot = {}
areas_by_plot = {}

grid.values_with_positions.each do |cell, pos|
  # Increment the area of this plot
  areas_by_plot[cell[:plot]] ||= 0
  areas_by_plot[cell[:plot]] += 1

  # Get the list of adjacent positions that are of a different plot (up to 4)
  neighbour_mismatch = pos.neighbours.select { |n_pos| !n_pos.in_bounds?(grid.dim) || grid[n_pos][:plot] != cell[:plot] }

  # For each mismatch, we'll either update an existing wall or record a new one.
  neighbour_mismatch.each do |neighbour|
    # is the wall on my left, right, up or down from the current cell
    dir = neighbour - pos

    # where could we have seen this wall previously?
    # if the wall is vertical (ie dir is left/right), then we could have seen it at the cell directly above us.
    # if the wall is horizontal (ie dir is up/down), then we could have seen it at the cell directly to the left.
    last_known_pos = pos + ([Vect2::left, Vect2::right].include?(dir) ? Vect2.up : Vect2.left)

    # If we have seen this wall before, update the last_saw_at to our current position
    # If we have not seen the wall before, its a new wall. So add it to the list of walls.
    walls_by_plot[cell[:plot]] ||= []
    existing = walls_by_plot[cell[:plot]].find { |w| w[:dir] == dir && w[:last_saw_at] == last_known_pos }
    if existing
      existing[:last_saw_at] = pos
    else
      walls_by_plot[cell[:plot]] << { dir: dir, last_saw_at: pos }
    end
  end
end


# Stage 3: Calculate the result
puts areas_by_plot.keys.sum { |plot| areas_by_plot[plot] * walls_by_plot[plot].length }
