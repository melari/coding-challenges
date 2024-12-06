class Vect2
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def add(other)
    Vect2.new(x + other.x, y + other.y)
  end

  def rotate_clockwise
    Vect2.new(-y, x)
  end

  def self.up
    Vect2.new(0, -1)
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def to_s
    "Vect2[#{x}, #{y}]"
  end

  def inspect
    to_s
  end
end

class Simulator
  def sim(initial_state)
    state = initial_state
    loop do
      result = sim_step(state)
      state = result[:next_state]
      return result if result[:completed]
    end
  end

  private def out_of_bounds?(pos, map)
    pos.x < 0 || pos.y < 0 || pos.x >= map[0].length || pos.y >= map.length
  end

  private def sim_step(state)
    next_state = state

    # either take a step, or rotate (not both)
    ahead = state[:gaurd_pos].add(state[:gaurd_dir])
    cell_ahead = next_state.dig(:map, ahead.y, ahead.x, :type)
    action = cell_ahead == WALL ? :rotate : :walk
    if action == :rotate
      next_state[:gaurd_dir] = next_state[:gaurd_dir].rotate_clockwise
    else
      next_state[:gaurd_pos] = ahead
    end

    if out_of_bounds?(next_state[:gaurd_pos], next_state[:map])
      return{
        next_state: next_state,
        completed: :gaurd_left_map,
      }
    end

    # If we walked, check if we looped. If not, "visit" the new cell.
    if action == :walk
      current_cell = next_state[:map][next_state[:gaurd_pos].y][next_state[:gaurd_pos].x]
      next_state[:cells_visited] += 1 if current_cell[:visited].none? # first time here in any orientation
      if current_cell[:visited].include?(next_state[:gaurd_dir]) # we've been here in this exact orientation
        return {
          next_state: next_state,
          completed: :gaurd_looped
        }
      else
        current_cell[:visited] << next_state[:gaurd_dir]
      end
    end

    {
      next_state: next_state,
      completed: false
    }
  end
end


# === CONSTANTS / LOAD INPUT ===

EMPTY = '.'
WALL = '#'
GAURD = '^'

def initial_state
  gaurd_pos = {}
  map = File.open('input.txt').map.with_index do |row, y|
    row.chomp.chars.map.with_index do |pos, x|
      gaurd_pos = Vect2.new(x, y) if pos == GAURD
      {
        type: pos == GAURD ? EMPTY : pos,
        visited: pos == GAURD ? [Vect2.up] : []
      }
    end
  end
  {
    gaurd_pos: gaurd_pos,
    gaurd_dir: Vect2.up,
    map: map,
    cells_visited: 1,
  }
end

simulator = Simulator.new


# === PART 1 ===
result = simulator.sim(initial_state)
puts result[:next_state][:cells_visited]


# === PART 2 ===
count = 0
unmodified = initial_state
w = unmodified[:map][0].length.to_f
h = unmodified[:map].length.to_f

unmodified[:map].each_with_index do |row, y|
  row.each_with_index do |cell, x|
    print "checking: [#{x},#{y}] (#{((x + y*w) / (w * h) * 100).round(2)}%)    \r"
    $stdout.flush

    next if x == unmodified[:gaurd_pos].x && y == unmodified[:gaurd_pos].y
    next unless cell[:type] == EMPTY
    next if result[:next_state][:map][y][x][:visited].none?

    state = initial_state
    state[:map][y][x][:type] = WALL
    count += 1 if simulator.sim(state)[:completed] == :gaurd_looped
  end
end

print count
puts "                                         "
