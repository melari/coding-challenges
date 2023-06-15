OPENERS = ['{', '(', '<', '[']
PAIRS = {
  '{' => '}',
  '(' => ')',
  '<' => '>',
  '[' => ']',
  '}' => '{',
  ')' => '(',
  '>' => '<',
  ']' => '[',
}
POINTS = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4,
}

input = File.read("input.txt").split("\n")

scores = input.map do |line|
  chars = line.split('')
  stack = []
  chars.each do |char|
    case char
    when *OPENERS
      stack.push(char)
    else
      if PAIRS[stack.pop] != char
        stack = [] # line is corrupt, discard by assuming it is complete.
        break
      end
    end
  end

  next nil if stack.empty?
  stack.reverse.reduce(0) { |points, c| points * 5 + POINTS[PAIRS[c]] }
end.compact

puts scores.sort[scores.count / 2]
