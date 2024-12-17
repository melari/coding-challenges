def run(a)
  lines = File.read('input.txt').split("\n")

  b = lines[1][12..].to_i
  c = lines[2][12..].to_i
  rom = lines[4][9..].split(',').map(&:to_i)

  pc = 0
  out = []

  while pc < rom.length
    lit = rom[pc+1]
    combo = case lit
            when 0, 1, 2, 3 then lit
            when 4 then a
            when 5 then b
            when 6 then c
            when 7 then nil
            end

    case rom[pc]
    when 0
      a /=  2 ** combo
    when 1
      b = b ^ lit
    when 2
      b = combo % 8
    when 3
      next (pc = lit) if a != 0
    when 4
      b = b ^ c
    when 5
      out << combo % 8
    when 6
      b = a / (2 ** combo)
    when 7
      c = a / (2 ** combo)
    end

    pc += 2
  end

  out
end

lines = File.read('input.txt').split("\n")
rom = lines[4][9..].split(',').map(&:to_i)
candidates = [0]
(1..rom.length).each do |digit|
  candidates = candidates.flat_map do |candidate|
    (0..7).map do |option|
      check = candidate * 8 + option
      run(check) == rom.last(digit) ? check : nil
    end.compact
  end
end

puts candidates.min
