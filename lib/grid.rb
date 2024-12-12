require_relative 'vector.rb'

class Grid
  def initialize(val)
    @val = val
  end

  def self.from_file(file, row_divider: "\n", column_divider: '')
    Grid.from_str(File.read(file), row_divider: row_divider, column_divider: column_divider)
  end

  def self.from_str(str, row_divider: "\n", column_divider: '')
    str
      .split(row_divider)
      .map { |row| row.split(column_divider) }
      .yield_self { |val| Grid.new(val) }
  end

  def map(&block)
    values_with_positions.each do |value, position|
      self[position] = yield value
    end
    self
  end

  def w
    @val[0]&.length || 0
  end

  def h
    @val.length
  end

  def dim
    Vect2[w,h]
  end

  # [x,y] OR [Vect2]
  def [](*args)
    if args.length == 1 && args[0].is_a?(Vect2)
      @val.dig(args[0].y, args[0].x)
    elsif args.length == 2 && args[0].is_a?(Integer) && args[1].is_a?(Integer)
      @val.dig(args[1], args[0])
    else
      raise ArgumentError.new('args should be: (x, y) OR (vect2)')
    end
  end

  def []=(*args)
    value = args.pop
    if args.length == 1 && args[0].is_a?(Vect2)
      @val[args[0].y][args[0].x] = value
    elsif args.length == 2 && args[0].is_a?(Integer) && args[1].is_a?(Integer)
      @val[args[1]][args[0]] = value
    else
      raise ArgumentError.new('args should be: (x, y) OR (vect2)')
    end
  end

  def rows
    @val
  end

  def columns
    Enumerator.new do |yielder|
      (0..w-1).each do |x|
        yielder << rows.map { |row| row[x] }
      end
    end
  end

  def values
    Enumerator::Lazy.new(values_with_positions) do |yielder, (value, _position)|
      yielder << value
    end
  end

  def values_with_positions
    Enumerator.new do |yielder|
      rows.each_with_index { |row, y| row.each_with_index { |value, x| yielder << [value, Vect2[x,y]] } }
    end
  end

  def neighbours(pos)
    pos.bounded_neighbours(dim).map { |n| [ n, self[n] ] }
  end

  def inspect
    gen_str(:inspect)
  end

  def to_s
    gen_str(:to_s)
  end

  private

  def gen_str(method)
    "┌───[ Grid (#{w} x #{h}) ]\n" + rows.map do |row|
      "│ " + row.map { |value| value.send(method) }.join(' ')
    end.join("\n") + "\n└───"
  end
end
