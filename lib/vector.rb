require 'matrix'

class Vect2 < Vector
  def x; self[0]; end
  def y; self[1]; end
  def self.zero; super(2); end
  def self.up; Vect2[0, -1]; end
  def self.down; Vect2[0, 1]; end
  def self.right; Vect2[1, 0]; end
  def self.left; Vect2[-1, 0]; end

  def rotate_clockwise; Vect2[-y,x]; end
  def rotate_counterclockwise; Vect[y,-x]; end

  def neighbours
    [self + Vect2.up, self + Vect2.down, self + Vect2.right, self + Vect2.left]
  end

  # bounded_neighbours(width, height)
  # bounded_neighbours(minx:, miny:, maxx:, maxy:)
  def bounded_neighbours(*args)
    if args.length == 1 && args[0].is_a?(Hash) # bounding box
      minx = args.dig(0, :minx)
      miny = args.dig(0, :miny)
      maxx = args.dig(0, :maxx)
      maxy = args.dig(0, :maxy)
    elsif args.length == 2 && args[0].is_a?(Integer) && args[1].is_a?(Integer) # width / height
      minx = 0
      miny = 0
      maxx = args[0] - 1
      maxy = args[1] - 1
    elsif args.length == 1 && args[0].is_a?(Vect2) # width / height
      minx = 0
      miny = 0
      maxx = args[0].x - 1
      maxy = args[0].y - 1
    end

    raise ArgumentError.new('args should either be: (2D Array) OR (width, height) OR (minx:, miny:, maxx:, maxy:)') unless minx && miny && maxx && maxy

    neighbours.select { |n| n.in_bounds?(minx: minx, miny: miny, maxx: maxx, maxy: maxy) }
  end

  def in_bounds?(minx:, miny:, maxx:, maxy:)
    x >= minx && y >= miny && x <= maxx && y <= maxy
  end

  # Allow for expanding x/y in blocks
  # eg [...vectors...].each { |x, y| }
  def to_ary
    to_a
  end
end

class Array
  # Allow indexing into 2D arrays by a Vect2
  # For example consider an nested array representing this grid of values:
  # 1 2 3
  # 4 5 6
  # 7 8 9
  # In array form this is [[1,2,3],[4,5,6],[7,8,9]]
  #
  # This patch allows indexing the array like this:
  # pos = Vect2[2,1]
  # val = map[pos]
  # In which case, the returned val is 6
  original = instance_method(:[])
  define_method(:[]) do |first, *other|
    return original.bind(self).(first, *other) unless other.length == 0 && first.is_a?(Vect2)
    self[first.y][first.x]
  end

  # Vector of the width/height dimensions of this 2D array
  def dim
    Vect2[self[0]&.length || 0, length]
  end
end
