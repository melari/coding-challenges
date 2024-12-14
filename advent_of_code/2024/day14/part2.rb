require_relative '../../../lib/vector.rb'

DIM = Vect2[101, 103]
ROBOTS = File.open('input.txt').map do |line|
  px, py, vx, vy = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/).captures
  { pos: Vect2[px.to_i, py.to_i], vel: Vect2[vx.to_i, vy.to_i] }
end

def draw(step)
  puts step
  positions = ROBOTS.map do |robot|
    (robot[:pos] + robot[:vel] * (step)) % DIM
  end

  (0..DIM.y-1).each do |y|
    (0..DIM.x-1).map do |x|
      positions.any? { |p| p == Vect2[x,y] } ? '█' : ' '
    end.tap { |line| puts line.join }
  end
end

draw(7338) # the answer i found after watching the matrix for a while
sleep(5)

# here's how i searched in the first place.
# noticed a pattern, the tiles converge every 101 (width) iterations starting from step 66 (ie 66, 167, 168)
(0..).each { |i| draw(66 + 101*i) }
