graph = {}
updates = []

File.open('input.txt').each do |line|
  if line.include?('|')
    parts = line.split('|').map(&:to_i)
    graph[parts[0]] ||= []
    graph[parts[0]] << parts[1]
  elsif line.include?(',')
    updates << line.split(',').map(&:to_i)
  end
end

sortfn = lambda do |a, b|
  return -1 if (graph[a] || []).include?(b)
  return 1 if (graph[b] || []).include?(a)
  0
end

# part 1
updates.sum do |update|
  fixed = update.sort(&sortfn)
  fixed == update ? fixed[fixed.length/2] : 0
end.tap { |r| p(r) }

# part 2
updates.sum do |update|
  fixed = update.sort(&sortfn)
  fixed != update ? fixed[fixed.length/2] : 0
end.tap { |r| p(r) }
