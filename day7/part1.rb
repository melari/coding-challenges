input = File.read("input.txt").split(",").map(&:to_i)
puts Range.new(*input.minmax).map { |x| input.sum { |i| (i - x).abs } }.min
