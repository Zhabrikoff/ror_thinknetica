alphabet = ("a".."z").to_a

vowels = {}

alphabet.each_with_index { |letter, index| vowels[letter] = index if "aeiou".include?(letter) }

puts vowels
