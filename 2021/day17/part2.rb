require 'set'
target = [(282..314), (-80..-45)]

axis_independent_hits = {
}

# Populate by xspeeds
(0..target[0].max).each do |x_i|
  xspeed = x_i
  x = 0
  step = 0
  loop do
    if target[0].include?(x)
      axis_independent_hits[step] ||= { x: [], y: [] }
      axis_independent_hits[step][:x] << x_i
    end
    break if x > target[0].max || step > -target[1].min*3
    x += xspeed
    xspeed -= 1 if xspeed > 0
    step += 1
  end
end

# Populate by yspeeds
(target[1].min..(-target[1].min)).each do |y_i|
  yspeed = y_i
  y = 0
  step = 0
  loop do
    if target[1].include?(y)
      axis_independent_hits[step] ||= { x: [], y: [] }
      axis_independent_hits[step][:y] << y_i
    end
    break if y < target[1].min
    y += yspeed
    yspeed -= 1
    step += 1
  end
end

unique_combinations = Set.new
axis_independent_hits.values.each do |hits|
  hits[:x].each do |x|
    hits[:y].each do |y|
      unique_combinations << [x, y]
    end
  end
end

pp unique_combinations.count
