class PassengerCarriage < Carriage
  validate :number, :presence
  validate :number, :format, /^[a-z0-9]{6}$/i
  validate :number, :class_type, String

  def initialize(number, place)
    @type = :passenger
    super
  end

  def take_place
    @used_place += 1 if free_place.positive?
  end
end
