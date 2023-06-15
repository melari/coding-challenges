SIGNAL_LENGTHS = {
  2 => [1],
  3 => [7],
  4 => [4],
  5 => [2, 3, 5],
  6 => [0, 6, 9],
  7 => [8],
}

input = File.read("input.txt").split("\n").map do |line|
  signals, output = line.split(" | ")
  { signals: signals.split(" "), output: output.split(" ") }
end

puts(input.sum do |i|
  i[:output].count { |o| SIGNAL_LENGTHS[o.size].one? }
end)
