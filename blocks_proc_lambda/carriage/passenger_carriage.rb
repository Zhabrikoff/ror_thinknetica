class PassengerCarriage < Carriage
  attr_accessor :free_seats
  attr_reader :seats

  def initialize(number, seats)
    @type = :passenger
    @seats = seats
    @free_seats = seats
    super(number)
  end

  def take_seat
    self.free_seats -= 1 if free_seats.positive?
  end

  def occupied_seats
    @seats - @free_seats
  end
end
