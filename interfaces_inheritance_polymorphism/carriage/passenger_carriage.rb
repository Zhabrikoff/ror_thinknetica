class PassengerCarriage < Carriage
  def initialize(number)
    @type = :passenger
    super
  end
end
