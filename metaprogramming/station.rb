class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  validate :name, :presence
  validate :name, :format, /^[a-z0-9]{6}$/i
  validate :name, :class_type, String

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    validate!
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

  def each_train(&block)
    trains.each(&block) if block_given?
  end
end
