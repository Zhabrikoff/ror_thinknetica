class Train
  attr_accessor :speed, :quantity_of_carriage
  attr_reader :type

  def initialize(number, type, quantity_of_carriage)
    @number = number
    @type = type
    @quantity_of_carriage = quantity_of_carriage
    @speed = 0
  end

  def stop
    self.speed = 0
  end

  def add_carriage
    self.quantity_of_carriage += 1 if speed.zero?
  end

  def remove_carriage
    self.quantity_of_carriage -= 1 if speed.zero? && !quantity_of_carriage.zero?
  end

  def route=(route)
    @current_index = 0
    @route = route
    current_station.take_train(self)
  end

  def current_station
    @route.stations[@current_index]
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
    @route.stations[@current_index - 1] if !@current_index.zero?
  end
end
