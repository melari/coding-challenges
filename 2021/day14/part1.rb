input = File.read("input.txt").split("\n")

state = Hash.new { 0 }
starting_state = input.shift
first_pair = starting_state[0..1] # The very first pair of the true full state
(1..starting_state.length-1).each do |i|
  state[starting_state[i-1..i]] += 1
end

input.shift # remove empty line

# load remaining input lines as a transformation hash
transformations = input.map do |line|
  match = /^(?<a>[A-Z])(?<b>[A-Z]) -> (?<new>[A-Z])$/.match(line)
  raise if match.nil?
  [match[:a] + match[:b], [match[:a] + match[:new], match[:new] + match[:b]]]
end.to_h

# apply transformation
10.times do
  next_state = state.dup
  next_first_pair = first_pair
  transformations.each do |target, result|
    result.each { |r| next_state[r] += state[target] }
    next_state[target] -= state[target]
    next_first_pair = result.first if first_pair == target
  end
  state = next_state
  first_pair = next_first_pair
end

# count the elements
# Because element pairs overlap, we only count the second part of each pair.
# We must then add +1 for the very first element in the state, since it will
# not show up in the second position of any pair.
element_counts = Hash.new{0}
state.each do |pair, count|
  element_counts[pair[1]] += count
end
element_counts[first_pair[0]] += 1

# get the least/most common
min, max = element_counts.values.minmax
pp max - min
