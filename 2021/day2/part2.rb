aim = 0
pos = [0, 0]
File.read("input.txt").split("\n").each do |line|
  command, amount = line.split(" ")
  case command
  when 'forward'
    pos[0] += amount.to_i
    pos[1] += aim * amount.to_i
  when 'up'
    aim -= amount.to_i
  when 'down'
    aim += amount.to_i
  end
end

puts pos
puts pos.reduce(&:*)
