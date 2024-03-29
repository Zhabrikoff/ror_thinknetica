basket = {}

loop do
  puts "Enter product name"
  product_name = gets.chomp
  break if product_name == "stop"

  puts "Enter unit price"
  unit_price = gets.chomp.to_f

  puts "Enter quantity of goods purchased"
  quantity = gets.chomp.to_f

  basket[product_name] = { unit_price: unit_price, quantity: quantity, total_amount: unit_price * quantity }
end

total_amount = 0

basket.each do |product_name, product_info|
  puts "#{product_name} - " \
       "Unit price: #{product_info[:unit_price]}, " \
       "Quantity: #{product_info[:quantity]}, " \
       "Total amount for each product: #{product_info[:total_amount]}"

  total_amount += product_info[:unit_price] * product_info[:quantity]
end

puts "Total amount: #{total_amount}"
