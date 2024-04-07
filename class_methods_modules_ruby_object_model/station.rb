class Station
  include InstanceCounter

  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []

    @@stations << self

    register_instance
  end

  def take_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def trains_by_type
    count = Hash.new(0)

    trains.each do |train|
      count[train.type] += 1
    end

    count
  end
end
