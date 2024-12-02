reports = File.open('input.txt').map do |report|
  report.split(' ').map(&:to_i)
end

# part 1
def safe?(r)
  up = r[0] < r[1] ? 1 : -1
  r.each_cons(2) do |a, b|
    d = (b - a) * up
    return false if d < 1 || d > 3
  end
  true
end

puts reports.count { |r| safe?(r) }


# part 2
# brute force, but given the small input size, this is way easier to read without noticeable speed impact.
def safe_with_tolerance?(r)
  return true if safe?(r)
  r.each_with_index do |_, i|
    return true if safe?(r.dup.tap { |x| x.delete_at(i) })
  end
  false
end

puts reports.count { |r| safe_with_tolerance?(r) }
