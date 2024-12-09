disk = File.read('input.txt').chomp.chars.map(&:to_i)

p1 = 0
p2 = disk.length - 1

# list of segments, with no space between
# one segment is { id: x, length: y }
compressed = []

# We should start the loop with p1 pointing to an empty gap
compressed << { id: p1/2, length: disk[p1] }
p1 += 1

loop do
  # if the pointers are beside eachother, just shift the full file over and we're done
  if p2 == p1 + 1
    compressed << { id: p2/2, length: disk[p2] }
    break
  end

  # Move as much as we can into the gap
  amount_moved = [disk[p1], disk[p2]].min
  compressed << { id: p2/2, length: amount_moved }
  disk[p1] -= amount_moved
  disk[p2] -= amount_moved

  # If we've finished moving the file, find another one to move
  p2 -= 2 if disk[p2] == 0

  # if the gap is filled, move over the next file to find another gap
  if disk[p1] == 0
    p1 += 1
    compressed << { id: p1/2, length: disk[p1] }
    p1 += 1
  end
end

# Calculate checksum
pos = 0
checksum = 0
compressed.each do |segment|
  next_pos = pos + segment[:length]
  checksum += segment[:id] * (next_pos - pos) * (pos + next_pos - 1) / 2  # modified version of the arithmetic series: S=(b-a+1)*(a+b)/2
  pos = next_pos
end

puts checksum
