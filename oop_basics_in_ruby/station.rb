class Station
  attr_reader :trains

  def initialize(name)
    @name = name
    @trains = []
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
