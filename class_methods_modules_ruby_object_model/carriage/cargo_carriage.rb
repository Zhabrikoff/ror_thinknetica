class CargoCarriage < Carriage
  def initialize(number)
    @type = :cargo
    super
  end
end
