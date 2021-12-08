input = File.read("input.txt").split("\n").map { |line| line.split('').map(&:to_i) }

options = input
index = 0
until options.one?
  ones = options.count { |o| o[index] == 1 }
  zeros = options.count - ones
  higher_value = ones >= zeros ? 1 : 0
  options = options.select { |o| o[index] == higher_value }
  index += 1
end
generator_rating = options.first.join('').to_i(2)

options = input
index = 0
until options.one?
  ones = options.count { |o| o[index] == 1 }
  zeros = options.count - ones
  higher_value = ones >= zeros ? 1 : 0
  options = options.select { |o| o[index] != higher_value }
  index += 1
end
scrubber_rating = options.first.join('').to_i(2)

puts generator_rating * scrubber_rating


