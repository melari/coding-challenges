total = File.read('input.txt').split("\n\n").sum do |machine|
  ax, ay, bx, by, px, py = machine.scan(/\d+/).map(&:to_i)
  px += 10000000000000
  py += 10000000000000
  a = (py*bx-by*px)/(ay*bx-by*ax)
  b = (py*ax-ay*px)/(by*ax-ay*bx)
  possible = a*ax+b*bx == px && a*ay+b*by == py
  possible ? 3*a + b : 0
end
puts total
