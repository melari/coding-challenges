input = File.read("input.txt").split("\n")
draws = input.shift.split(",").map(&:to_i)
boards = []
board_index = {}
winners = []

until input.empty?
  input.shift # empty line
  boards << []
  5.times do
    boards[-1] << input.shift.split(' ').map do |x|
      x = x.to_i
      board_index[x] ||= []
      board_index[x] << boards.count - 1
      { value: x, marked: false }
    end
  end
end

draws.each do |draw|
  puts "DRAW: #{draw}"
  board_index[draw].each do |board_index|
    next if winners.include?(board_index)

    # find
    fx, fy = nil, nil
    board = boards[board_index]
    board.each_with_index do |row, y|
      row.each_with_index do |entry, x|
        entry[:value] == draw && (fx = x) && (fy = y)
      end
    end

    next unless fx && fy

    # mark
    board[fy][fx][:marked] = true

    # check for win
    if board[fy].all? { |v| v[:marked] } || board.all? { |row| row[fx][:marked] }
      winners << board_index
      # score
      score = 0
      board.each do |row|
        row.each do |entry|
          score += entry[:value] unless entry[:marked]
        end
      end
      score *= draw
      puts "WINNER SCORE: #{score}"
    end
  end
end
