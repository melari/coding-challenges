require 'matrix'

class Vect2 < Vector
  def self.zero; super(2); end
  def self.up; Vect2[0, -1]; end
  def self.down; Vect2[0, 1]; end
  def self.right; Vect2[1, 0]; end
  def self.left; Vect2[-1, 0]; end
  def self.upright; Vect2[1, -1]; end
  def self.upleft; Vect2[-1, -1]; end
  def self.downright; Vect2[1, 1]; end
  def self.downleft; Vect2[-1, 1]; end

  def x; self[0]; end
  def y; self[1]; end
  def rotate_clockwise; Vect2[-y,x]; end
  def rotate_counterclockwise; Vect[y,-x]; end

  def %(other)
    Vect2[x % other.x, y % other.y]
  end

  def neighbours(include_diagonal: false)
    n = [self + Vect2.up, self + Vect2.down, self + Vect2.right, self + Vect2.left]
    n += [self + Vect2.upright, self + Vect2.upleft, self + Vect2.downright, self + Vect2.downleft] if include_diagonal
    n
  end

  def bounded_neighbours(*args)
    neighbours.select { |n| n.in_bounds?(*args) }
  end

  def bounded_edges(*args)
    rejects = bounded_neighbours(*args)
    neighbours.reject { |n| rejects.include?(n) }
  end

  def in_bounds?(*args)
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

    x >= minx && y >= miny && x <= maxx && y <= maxy
  end

  # Allow for expanding x/y in blocks
  # eg [...vectors...].each { |x, y| }
  def to_ary
    to_a
  end
end
