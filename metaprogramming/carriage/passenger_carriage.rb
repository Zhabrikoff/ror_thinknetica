class PassengerCarriage < Carriage
  def initialize(number, place)
    @type = :passenger
    super
  end

  def take_place
    @used_place += 1 if free_place.positive?
  end
end
