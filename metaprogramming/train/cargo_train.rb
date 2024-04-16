class CargoTrain < Train
  validate :number, :presence
  validate :number, :format, /^[a-z0-9]{3}(-[a-z0-9]{2})?$/i
  validate :number, :class_type, String

  def initialize(number)
    @type = :cargo
    super
  end
end
