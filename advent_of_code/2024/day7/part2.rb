def is_possible?(target, nums)
  (0..(3 ** (nums.length-1))-1).any? do |pattern|
    target == nums[1..-1]
      .each_with_index
      .reduce(nums[0]) do |acc, (num, i)|
        case pattern.to_s(3)[-i-1].to_i
        when 0 then acc + num
        when 1 then acc * num
        when 2 then "#{acc}#{num}".to_i
        end
      end
  end
end

File.open('input.txt')
    .map { |l| l.split(':') }
    .map { |parts| [parts.first.to_i, parts.last.split(' ').map(&:to_i)] }
    .select { |target, nums| is_possible?(target, nums) }
    .map(&:first)
    .sum
    .tap { |r| p(r) }
