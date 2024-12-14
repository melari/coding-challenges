require_relative '../../../lib/vector.rb'

DIM = Vect2[101, 103]
#DIM = Vect2[11, 7]
SIM_STEPS = 100

robots = File.open('input.txt').map do |line|
  px, py, vx, vy = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/).captures
  { pos: Vect2[px.to_i, py.to_i], vel: Vect2[vx.to_i, vy.to_i] }
end

counts = [0,0,0,0] # up-left, up-right, down-right, down-left
robots.each do |robot|
  robot[:pos] = (robot[:pos] + robot[:vel] * SIM_STEPS) % DIM

  counts[0] += 1 if robot[:pos].x < DIM.x/2 && robot[:pos].y < DIM.y/2
  counts[1] += 1 if robot[:pos].x > DIM.x/2 && robot[:pos].y < DIM.y/2
  counts[2] += 1 if robot[:pos].x > DIM.x/2 && robot[:pos].y > DIM.y/2
  counts[3] += 1 if robot[:pos].x < DIM.x/2 && robot[:pos].y > DIM.y/2
end

puts counts.reduce(&:*)
