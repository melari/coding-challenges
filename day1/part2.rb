window = []
sums = File.read("input.txt").split("\n").map(&:to_i).map do |n|
  window << n
  window.shift if window.count > 3
  window.sum if window.count == 3
end.compact

prev = sums.shift
result = sums.count do |i|
  r = i > prev
  prev = i
  r
end
puts result
