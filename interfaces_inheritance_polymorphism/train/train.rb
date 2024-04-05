class Train
  attr_accessor :speed
  attr_reader :type, :number, :carriages, :route

  def initialize(number)
    @number = number
    @speed = 0
    @carriages = []
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
    @route.stations[@current_index] if !@route.nil?
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
