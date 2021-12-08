input = File.read("input.txt").split(",").map(&:to_i)
puts Range.new(*input.minmax).map { |x| input.sum { |i| (x-i).abs*((x-i).abs+1)/2 } }.min
