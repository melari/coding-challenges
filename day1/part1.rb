input = File.read("input.txt").split("\n").map(&:to_i)
prev = input.shift
result = input.count do |i|
  r = i > prev
  prev = i
  r
end
puts result
