puts "Enter the first side of the triangle"
first_side = gets.chomp.to_i

puts "Enter the second side of the triangle"
second_side = gets.chomp.to_i

puts "Enter the third side of the triangle"
third_side = gets.chomp.to_i

if first_side + second_side < third_side || second_side + third_side < first_side || first_side + third_side < second_side
  return puts "These sides cannot be used to form a triangle"
end

sides = [first_side, second_side, third_side]
max_side = [first_side, second_side, third_side].max
other_sides = sides - [max_side]

if first_side == second_side && second_side == third_side
  puts "Equilateral triangle"
end

if first_side == second_side || first_side == third_side || second_side == third_side
  puts "Isosceles triangle"
end

if max_side ** 2 == other_sides.reduce(0) { |sum, side| sum + side ** 2 }
  puts "Right triangle"
end
