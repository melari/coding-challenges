def insert(arr, value)
  i = arr.bsearch_index { |x| x >= value }
  return arr + [value] if i.nil?
  arr.insert(i, value)
end

list1 = []
list2 = []
File.open('input.txt').each do |line|
  parts = line.split('   ')
  list1 = insert(list1, parts.first.to_i)
  list2 = insert(list2, parts.last.to_i)
end

# part 1
puts list1.zip(list2).map { |a, b| (a - b).abs }.sum


# part 2
result = list1.map do |a|
  c = 0
  while (b = list2.first) && b <= a && list2.shift
    c += 1 if a == b
  end
  c * a
end.sum

puts result
