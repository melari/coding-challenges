original_rock_counts = File.read('input.txt').chomp.split(' ').map(&:to_i).each_with_object(Hash.new(0)) { |rock, acc| acc[rock] += 1 }

def step(rock_counts)
  new_counts = Hash.new(0)
  rock_counts.each do |rock, count|
    next new_counts[1] += count if rock == 0
    if rock.digits.length.even?
      parts = rock.digits.reverse.each_slice(rock.digits.length/2).map(&:join).map(&:to_i)
      new_counts[parts[0]] += count
      new_counts[parts[1]] += count
      next
    end
    new_counts[rock * 2024] += count
  end
  new_counts
end

# part 1
rock_counts = original_rock_counts
25.times { rock_counts = step(rock_counts) }
puts rock_counts.values.sum

# part 2
rock_counts = original_rock_counts
75.times { rock_counts = step(rock_counts) }
puts rock_counts.values.sum
