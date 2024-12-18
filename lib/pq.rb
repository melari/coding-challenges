class PQ
  attr_reader :queue

  def initialize(heuristic)
    @heuristic = heuristic
    @queue = []
  end

  def self.increasing(&block)
    return PQ.new(-> (a, b) { yield(a) >= yield(b) }) if block_given?
    PQ.new(-> (a, b) { a >= b })
  end

  def self.decreasing(&block)
    return PQ.new(-> (a, b) { yield(a) <= yield(b) }) if block_given?
    PQ.new(-> (a, b) { a <= b })
  end

  def push(value)
    i = queue.bsearch_index { |x| @heuristic.call(x, value) }
    if i.nil?
      @queue << value
    else
      @queue.insert(i, value)
    end
    self
  end

  def <<(value)
    push(value)
  end

  def pop
    @queue.shift
  end

  def peek
    @queue.first
  end

  def length
    @queue.length
  end

  def empty?
    !any?
  end

  def any?
    length > 0
  end

  def to_s
    inspect
  end

  def inspect
    "PQ:#{@queue.inspect}"
  end
end
