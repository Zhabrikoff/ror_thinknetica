puts "Enter the day"
day = gets.chomp.to_i

puts "Enter the month"
month = gets.chomp.to_i

puts "Enter the year"
year = gets.chomp.to_i

is_leap_year = (year % 4 == 0 && year % 100 != 0) || year % 400 == 0

number_of_days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
number_of_days_in_months[1] = 29 if is_leap_year

puts "Day number is #{number_of_days_in_months[0...month - 1].sum + day}"
