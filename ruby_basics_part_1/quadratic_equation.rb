puts "Enter the first coefficient"
a = gets.chomp.to_i

puts "Enter the second coefficient"
b = gets.chomp.to_i

puts "Enter the third coefficient"
c = gets.chomp.to_i

d = b ** 2 - 4 * a * c

if d > 0
  puts "Discriminant is #{d}, x1 = #{(-b + Math.sqrt(d)) / 2 * a}, x2 = #{(-b - Math.sqrt(d)) / 2 * a}"
elsif d == 0
  puts "Discriminant is #{d}, x = #{-b / 2 * a}"
else
  puts "Discriminant is #{d}, no roots"
end
