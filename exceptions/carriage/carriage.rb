class Carriage
  include Manufacturer

  attr_reader :type, :number

  def initialize(number)
    @number = number
  end
end
