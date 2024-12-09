disk = File.read('input.txt').chomp.chars.map(&:to_i)

segments = []
pos = 0
disk.each_slice(2).with_index do |(file_length, empty_length), id|
  segments << { id: id, length: file_length, moved: false }
  pos += file_length
  if empty_length && empty_length > 0
    segments << { id: nil, length: empty_length }
    pos += empty_length
  end
end

# pointer from end of segments array to skip stuff we will never move.
p = -1

while p > -segments.length
  segment = segments[p]
  next p -= 1 if segment[:id].nil? || segment[:moved] # skip over gaps and already moved files

  # find a gap
  gap_index = segments[0..p-1].find_index { |s| s[:id].nil? && s[:length] >= segment[:length] }
  next p -= 1 if gap_index.nil? # no gap big enough, ignore forever

  # move the segment
  segment[:moved] = true
  segments = segments.insert(gap_index, segment)

  # leave behind a gap where the segment came from (and combine with adjacent gaps)
  total_gap = segment[:length]
  if segments[p-1] && segments[p-1][:id].nil?
    total_gap += segments[p-1][:length]
    segments.delete_at(p-1)
  end
  if segments[p+1] && segments[p+1][:id].nil?
    total_gap += segments[p+1][:length]
    segments.delete_at(p+1)
    p += 1
  end
  segments[p] = { id: nil, length: total_gap }

  # adjust the gap (reduce length / delete)
  gap_index += 1
  segments[gap_index][:length] -= segment[:length] # reduce the remaining gap size
  segments.delete_at(gap_index) if segments[gap_index][:length] == 0

  # note: p does not change because we moved the segment left.
end

# Calculate checksum
pos = 0
checksum = 0
segments.each do |segment|
  next_pos = pos + segment[:length]
  checksum += segment[:id] * (next_pos - pos) * (pos + next_pos - 1) / 2 if segment[:id]  # modified version of the arithmetic series: S=(b-a+1)*(a+b)/2
  pos = next_pos
end

puts checksum
