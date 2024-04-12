class CargoCarriage < Carriage
  def initialize(number, place)
    @type = :cargo
    super
  end

  def take_place(volume)
    @used_place += volume if free_place >= volume
  end
end
