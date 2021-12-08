#  111
# 2   3
# 2   3
# 2   3
#  444
# 5   6
# 5   6
# 5   6
#  777

# length of signal => display number options
SIGNAL_LENGTHS = {
  2 => [1],
  3 => [7],
  4 => [4],
  5 => [2, 3, 5],
  6 => [0, 6, 9],
  7 => [8],
}

# display number => normal segments
NORMAL_SEGMENTS = {
  0 => [1, 2, 3, 5, 6, 7],
  1 => [3, 6],
  2 => [1, 3, 4, 5, 7],
  3 => [1, 3, 4, 6, 7],
  4 => [2, 3, 4, 6],
  5 => [1, 2, 4, 6, 7],
  6 => [1, 2, 4, 5, 6, 7],
  7 => [1, 3, 6],
  8 => [1, 2, 3, 4, 5, 6, 7],
  9 => [1, 2, 3, 4, 6, 7],
}

# Is it possible that given these segment_options, that
# the signal could be displaying the given number?
def display_possible?(display_number, signal, segment_options)
  working_signal = signal.dup
  NORMAL_SEGMENTS[display_number].each do |segment|
    signal_options_for_segment = segment_options.keys.filter { |k| segment_options[k].include?(segment) }
    found = false
    signal_options_for_segment.each do |option|
      if working_signal.include?(option)
        found = true
        working_signal.delete!(option)
        break
      end
    end
    return false unless found
  end

  working_signal.empty?
end

def possible_display_numbers(signal, segment_options)
  SIGNAL_LENGTHS[signal.size].filter { |n| display_possible?(n, signal, segment_options) }
end

input = File.read("input.txt").split("\n").map do |line|
  signals, output = line.split(" | ")
  { signals: signals.split(" "), output: output.split(" ") }
end

puts(input.sum do |i|
  # signal => segment options
  segment_options = {}
  ('a'..'g').each { |l| segment_options[l] = (1..7).to_a }

  until segment_options.values.all? { |v| v.one? } do
    i[:signals].each do |signal|
      display_number_options = possible_display_numbers(signal, segment_options)
      if display_number_options.one?
        segment_options.keys.each do |s|
          if signal.include?(s)
            segment_options[s].filter! { |option| NORMAL_SEGMENTS[display_number_options.first].include?(option) }
          else
            segment_options[s].filter! { |option| !NORMAL_SEGMENTS[display_number_options.first].include?(option) }
          end
        end
      end
    end
  end

  # decode the output
  i[:output].map do |signal|
    possible_display_numbers(signal, segment_options).first
  end.join.to_i
end)
