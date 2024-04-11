class Carriage
  include Manufacturer

  attr_reader :type, :number

  def initialize(number)
    @number = number
    validate!
  end

  def validate!
    raise "Invalid number format!" if number !~ /^[a-z0-9]{6}$/i
  end
end
