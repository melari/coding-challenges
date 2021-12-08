def vector_add(a, b)
  a.map.with_index { |d, i| d + b[i] }
end

def vector_sub(a, b)
  a.map.with_index { |d, i| d - b[i] }
end

BYTESIZE = 12
total = [0] * BYTESIZE
one_count = [0] * BYTESIZE

File.read("input.txt").split("\n").each do |line|
  total = vector_add(total, [1] * BYTESIZE)
  one_count = vector_add(one_count, line.split('').map(&:to_i))
end
zero_count = vector_sub(total, one_count)

gamma = one_count.map.with_index { |d, i| d > zero_count[i] ? 1 : 0 }.join('').to_i(2)
epsilon = one_count.map.with_index { |d, i| d < zero_count[i] ? 1 : 0 }.join('').to_i(2)

puts gamma * epsilon
