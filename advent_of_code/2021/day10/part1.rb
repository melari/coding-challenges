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
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
}

input = File.read("input.txt").split("\n")

score = input.sum do |line|
  chars = line.split('')
  stack = []
  points = 0
  chars.each do |char|
    case char
    when *OPENERS
      stack.push(char)
    else
      if PAIRS[stack.pop] != char
        points = POINTS[char]
        break
      end
    end
  end

  points
end

puts score
