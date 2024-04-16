class CargoCarriage < Carriage
  validate :number, :presence
  validate :number, :format, /^[a-z0-9]{6}$/i
  validate :number, :class_type, String

  def initialize(number, place)
    @type = :cargo
    super
  end

  def take_place(volume)
    @used_place += volume if free_place >= volume
  end
end
