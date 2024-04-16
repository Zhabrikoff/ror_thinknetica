class Train
  include InstanceCounter
  include Manufacturer
  include Accessors
  include Validation

  attr_accessor_with_history :speed
  attr_reader :type, :number, :carriages, :route

  @@trains = []

  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  def initialize(number)
    @number = number
    validate!

    @speed = 0
    @carriages = []

    @@trains << self

    register_instance
  end

  def stop
    self.speed = 0
  end

  def add_carriage(carriage)
    @carriages << carriage if speed.zero? && type == carriage.type
  end

  def remove_carriage(carriage)
    @carriages.delete(carriage) if speed.zero? && type == carriage.type
  end

  def route=(route)
    @current_index = 0
    @route = route
    current_station.take_train(self)
  end

  def current_station
    @route.stations[@current_index] unless @route.nil?
  end

  def move_to_next_station
    return if next_station.nil?

    current_station.send_train(self)
    @current_index += 1
    current_station.take_train(self)
  end

  def move_to_previous_station
    return if previous_station.nil?

    current_station.send_train(self)
    @current_index -= 1
    current_station.take_train(self)
  end

  def next_station
    @route.stations[@current_index + 1]
  end

  def previous_station
    @route.stations[@current_index - 1] unless @current_index.zero?
  end

  def each_carriage(&block)
    carriages.each(&block) if block_given?
  end
end
