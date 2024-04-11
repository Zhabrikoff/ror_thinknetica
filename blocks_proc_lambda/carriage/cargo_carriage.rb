class CargoCarriage < Carriage
  attr_accessor :free_space
  attr_reader :space

  def initialize(number, space)
    @type = :cargo
    @space = space
    @free_space = space
    super(number)
  end

  def take_up_space(value)
    self.free_space -= value if (free_space - value).positive?
  end

  def occupied_space
    space - free_space
  end
end
