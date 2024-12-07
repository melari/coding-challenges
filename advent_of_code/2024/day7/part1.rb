def is_possible?(target, nums)
  (0..(2 ** (nums.length-1))-1).any? do |pattern|
    target == nums[1..-1]
      .each_with_index
      .reduce(nums[0]) { |acc, (num, i)| (pattern & (2 ** i)) > 0 ? acc * num : acc + num }
  end
end

File.open('input.txt')
    .map { |l| l.split(':') }
    .map { |parts| [parts.first.to_i, parts.last.split(' ').map(&:to_i)] }
    .select { |target, nums| is_possible?(target, nums) }
    .map(&:first)
    .sum
    .tap { |r| p(r) }
