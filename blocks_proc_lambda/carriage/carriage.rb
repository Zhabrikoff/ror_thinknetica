class Carriage
  include Manufacturer

  attr_reader :type, :number, :total_place, :used_place

  def initialize(number, total_place)
    @number = number
    @total_place = total_place
    @used_place = 0
    validate!
  end

  def free_place
    @total_place - @used_place
  end

  def take_place
    raise "Should be implemented in subclasses"
  end

  def validate!
    raise "Invalid number format!" if number !~ /^[a-z0-9]{6}$/i
  end
end
