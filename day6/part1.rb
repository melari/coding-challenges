state = Array.new(9, 0)
File.read("input.txt").split(",").map(&:to_i).each do |starter|
  state[starter] += 1
end

80.times do
  state[7] += state[0]
  state.rotate!
end

puts state.sum
