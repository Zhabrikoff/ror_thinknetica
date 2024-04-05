require_relative "./carriage/carriage.rb"
require_relative "./carriage/passenger_carriage.rb"
require_relative "./carriage/cargo_carriage.rb"

require_relative "./train/train.rb"
require_relative "./train/passenger_train.rb"
require_relative "./train/cargo_train.rb"

require_relative "./route.rb"
require_relative "./station.rb"

class Railway
  attr_reader :routes, :stations, :trains, :carriages

  def initialize
    puts "Welcome to the railway!"
    @routes = []
    @stations = []
    @trains = []
    @carriages = []
    start
  end

  # Пользователь общается только с графическим интерфейсом, поэтому все методы скрываются от него
  private

  def start
    delimiter
    puts "1. Routes"
    puts "2. Stations"
    puts "3. Trains and Carriages"
    puts "0. Exit"
    menu = get_answer

    case menu
    when "0"
      return
    when "1"
      routes_menu_select
    when "2"
      stations_menu_select
    when "3"
      trains_and_carriages_menu_select
    else
      puts incorrect_choice
      start
    end
  end

  def routes_menu_select
    delimiter
    puts "1. Create a route"
    puts "2. Show routes"
    puts "3. Add a station to a route"
    puts "4. Remove a station from a route"
    puts "0. Main menu"
    routes_menu = get_answer

    case routes_menu
    when "0"
      start
    when "1"
      create_route
    when "2"
      delimiter
      show_routes
      routes_menu_select
    when "3"
      add_station_to_route
    when "4"
      remove_station_from_route
    else
      puts incorrect_choice
      routes_menu
    end
  end

  def stations_menu_select
    delimiter
    puts "1. Create a station"
    puts "2. Show stations"
    puts "0. Main menu"
    stations_menu = get_answer

    case stations_menu
    when "0"
      start
    when "1"
      create_station
    when "2"
      delimiter
      show_stations
      stations_menu_select
    else
      puts incorrect_choice
      stations_menu
    end
  end

  def trains_and_carriages_menu_select
    delimiter
    puts "1. Create a train"
    puts "2. Show trains"
    puts "3. Create a carriage"
    puts "4. Show carriages"
    puts "5. Add a carriage to a train"
    puts "6. Remove a carriage from a train"
    puts "7. Assign a train route"
    puts "8. Move the train to the next station"
    puts "9. Move the train to the previous station"
    puts "0. Main menu"
    trains_and_carriages_menu = get_answer

    case trains_and_carriages_menu
    when "0"
      start
    when "1"
      create_train
    when "2"
      delimiter
      show_trains
      trains_and_carriages_menu_select
    when "3"
      create_carriage
    when "4"
      delimiter
      show_carriages
      trains_and_carriages_menu_select
    when "5"
      add_carriage_to_train
    when "6"
      remove_carriage_to_train
    when "7"
      assign_train_route
    when "8"
      move_train_to_next_station
    when "9"
      move_train_to_previous_station
    else
      puts incorrect_choice
      trains_and_carriages_menu
    end
  end

  def create_train
    delimiter
    puts "Create a train"

    train_type_index = select_type_of_carriage_of_train

    puts "Enter train number:"
    train_number = get_answer

    case train_type_index
    when 0
      trains << CargoTrain.new(train_number)
    when 1
      trains << PassengerTrain.new(train_number)
    end

    puts "Train created!"
    trains_and_carriages_menu_select
  end

  def show_trains
    return trains_and_carriages_menu_select if trains_empty?

    puts "Trains:"
    trains.each_with_index do |train, index|
      print "#{index}. " \
            "#{train.number}, " \
            "type: #{train.type}, " \
            "carriages: [#{train.carriages.map { |carriage| carriage.number }.join(", ")}]"
      if train.current_station
        puts ", current station: #{train.current_station.name}"
      else
        puts
      end
    end
  end

  def create_carriage
    delimiter
    puts "Create a carriage"

    carriage_type_index = select_type_of_carriage_of_train

    puts "Enter carriage number:"
    carriage_number = get_answer

    case carriage_type_index
    when 0
      carriages << CargoCarriage.new(carriage_number)
    when 1
      carriages << PassengerCarriage.new(carriage_number)
    end

    puts "Carriage created!"
    trains_and_carriages_menu_select
  end

  def show_carriages(carriagesArray = carriages)
    return trains_and_carriages_menu_select if carriages_empty?

    puts "Carriages:"
    carriagesArray.each_with_index do |carriage, index|
      puts "#{index}. #{carriage.number}, type: #{carriage.type}"
    end
  end

  def carriages_by_type(type)
    array_of_carriages_by_type = carriages.select { |carriage| carriage.type == type }
    puts "There are no carriages of this type!" if array_of_carriages_by_type.empty?
    array_of_carriages_by_type
  end

  def show_carriages_by_type(type)
    array_of_carriages_by_type = carriages_by_type(type)
    return trains_and_carriages_menu_select if array_of_carriages_by_type.empty?
    puts "Carriages:"

    show_carriages(array_of_carriages_by_type)
  end

  def add_carriage_to_train
    delimiter
    return trains_and_carriages_menu_select if trains_empty? || carriages_empty?

    show_trains
    puts "Select the index of the trains:"
    train_type_index = check_index_is_correct(trains.length)
    train = trains[train_type_index]

    show_carriages_by_type(train.type)
    array_of_carriages_by_type = carriages_by_type(train.type)
    puts "Select the index of the carriage:"
    carriage_by_type_index = check_index_is_correct(array_of_carriages_by_type.length)

    train.add_carriage(array_of_carriages_by_type[carriage_by_type_index])
    puts "The carriage has been added to the train!"

    trains_and_carriages_menu_select
  end

  def remove_carriage_to_train
    delimiter
    return trains_and_carriages_menu_select if trains_empty? || carriages_empty?

    show_trains
    puts "Select the index of the trains:"
    train_type_index = check_index_is_correct(trains.length)
    train = trains[train_type_index]

    return puts "The selected train has no carriages!" if train.carriages.empty?

    puts "Carriages:"
    train.carriages.each_with_index { |carriage, index| puts "#{index}. #{carriage.number}, type: #{carriage.type}" }
    puts "Select the index of the carriage:"
    carriage_by_type_index = check_index_is_correct(train.carriages.length)

    train.remove_carriage(train.carriages[carriage_by_type_index])
    puts "The carriage has been removed to the train!"

    trains_and_carriages_menu_select
  end

  def assign_train_route
    delimiter
    return trains_and_carriages_menu_select if trains_empty? || routes_empty?

    train = select_train

    route_index = select_route_index

    train.route = routes[route_index]
    puts "The route has been assigned to the train!"

    trains_and_carriages_menu_select
  end

  def move_train_to_next_station
    delimiter
    return trains_and_carriages_menu_select if trains_empty? || routes_empty?

    train = select_train

    return trains_and_carriages_menu_select if check_if_route_assigned_to_train?(train)

    if train.next_station
      train.move_to_next_station
      puts "The train has been move to the next station!"
    else
      puts "This is the last station!"
    end

    trains_and_carriages_menu_select
  end

  def move_train_to_previous_station
    delimiter
    return trains_and_carriages_menu_select if trains_empty? || routes_empty?

    train = select_train

    return trains_and_carriages_menu_select if check_if_route_assigned_to_train?(train)

    if train.previous_station
      train.move_to_previous_station
      puts "The train has been move to the previous station!"
    else
      puts "This is the first station!"
    end

    trains_and_carriages_menu_select
  end

  def create_station
    delimiter
    puts "Create a station"
    puts "Enter station name:"
    station_name = get_answer
    stations << Station.new(station_name)
    puts "Station created!"
    stations_menu_select
  end

  def show_stations
    return stations_menu_select if stations_empty?

    puts "Stations:"
    stations.each_with_index do |station, index|
      puts "#{index}. #{station.name}"
    end
  end

  def create_route
    delimiter
    return routes_menu_select if stations_empty?

    puts "Create a route:"
    show_stations

    puts "Select the index of the first station:"
    first_station_index = check_index_is_correct(stations.length)

    puts "Select the index of the last station:"
    last_station_index = check_index_is_correct(stations.length)

    routes << Route.new(stations[first_station_index], stations[last_station_index])
    puts "Route created!"
    routes_menu_select
  end

  def show_routes
    return if routes_empty?

    puts "Routes:"
    routes.each_with_index do |route, index|
      puts "#{index}. Stations: #{route.stations.map { |station| station.name }.join(", ")}"
    end
  end

  def add_station_to_route
    delimiter
    return routes_menu_select if stations_empty? || routes_empty?

    route_index = select_route_index

    show_stations
    puts "Select station index:"
    station_index = check_index_is_correct(stations.length)

    routes[route_index].add_station(stations[station_index])
    puts "The station has been added to the route!"
    routes_menu_select
  end

  def remove_station_from_route
    delimiter
    return routes_menu_select if stations_empty? || routes_empty?

    route_index = select_route_index

    stations_of_route = routes[route_index].stations

    if stations_of_route.length < 3
      puts "You can't remove the first and last station!"
      return routes_menu_select
    end

    puts "Stations:"
    stations_of_route.each_with_index do |station, index|
      puts "#{index}. #{station.name}"
    end

    puts "Select station index:"
    station_index = check_index_is_correct(stations_of_route.length)

    routes[route_index].remove_station(stations_of_route[station_index])
    puts "The station has been removed to the route!"
    routes_menu_select
  end

  def stations_empty?
    puts "No stations!" if stations.empty?
    stations.empty?
  end

  def routes_empty?
    puts "No routes!" if routes.empty?
    routes.empty?
  end

  def trains_empty?
    puts "No trains!" if trains.empty?
    trains.empty?
  end

  def carriages_empty?
    puts "No carriages!" if carriages.empty?
    carriages.empty?
  end

  def types_of_trains_and_carriages
    [:cargo, :passenger]
  end

  def select_train
    show_trains
    puts "Select the index of the train:"
    train_type_index = check_index_is_correct(trains.length)
    trains[train_type_index]
  end

  def check_if_route_assigned_to_train?(train)
    puts "The route is not assigned to the train!" if train.route.nil?
    train.route.nil?
  end

  def select_type_of_carriage_of_train
    types_of_trains_and_carriages.each_with_index { |type, index| puts "#{index}. #{type}" }
    puts "Enter type index:"
    check_index_is_correct(types_of_trains_and_carriages.length)
  end

  def select_route_index
    show_routes
    puts "Select route index:"
    check_index_is_correct(routes.length)
  end

  def check_index_is_correct(array_length)
    loop do
      index_to_check = get_answer_i
      if (0..(array_length - 1)).include? (index_to_check)
        break index_to_check
      else
        puts "Select correct index:"
      end
    end
  end

  def get_answer
    gets.chomp
  end

  def get_answer_i
    gets.chomp.to_i
  end

  def incorrect_choice
    "Incorrect menu item selected, select the correct menu item!"
  end

  def delimiter
    puts "===================================="
  end
end
