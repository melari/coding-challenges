require_relative '../../../lib/grid.rb'

def visit(val, pos, metrics, grid, plot)
  metrics[plot] ||= { area: 0, perim: 0 }

  val[:plot] = plot
  metrics[plot][:area] += 1

  neighbours = grid.neighbours(pos)
  metrics[plot][:perim] += 4 - neighbours.length
  neighbours.each do |n_pos, n_val|
    if n_val[:crop] == val[:crop]
      next visit(n_val, n_pos, metrics, grid, plot) if n_val[:plot].nil?
      raise "Algorithm Failure" unless n_val[:plot] == plot
    else
      metrics[plot][:perim] += 1
    end
  end
end

grid = Grid.from_file('input.txt').map { |crop| { crop: crop, plot: nil } }

next_plot_id = 0
metrics = {}
grid.values_with_positions.each do |val, pos|
  visit(val, pos, metrics, grid, next_plot_id += 1) unless val[:plot]
end

puts metrics.sum { |_plot, measurements| measurements[:area] * measurements[:perim] }
