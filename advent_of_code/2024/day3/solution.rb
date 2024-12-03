input = File.read('input.txt')

MUL_REGEX = /mul\(([0-9]{1,3}),([0-9]{1,3})\)/

# part 1
puts input.scan(MUL_REGEX).map { |a, b| a.to_i * b.to_i }.sum

# part 2
enabled = true
nums = input.scan(/#{MUL_REGEX}|(do\(\))|(don't\(\))/).map do |a, b, en, dis|
  enabled = true if en
  enabled = false if dis
  enabled ? a.to_i * b.to_i : 0
end
puts nums.sum
