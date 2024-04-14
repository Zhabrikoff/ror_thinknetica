require_relative "./modules/manufacturer"
require_relative "./modules/instance_counter"
require_relative "./modules/validation"

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
    show_main_menu
  end

  # Пользователь общается только с графическим интерфейсом, поэтому все методы скрываются от него
  private

  ROUTES_MENU = [
    { id: "1", title: "Create a route", action: :create_route },
    { id: "2", title: "Show routes", action: :show_all_routes },
    { id: "3", title: "Add a station to a route", action: :add_station_to_route },
    { id: "4", title: "Remove a station from a route", action: :remove_station_from_route },
    { id: "0", title: "Main menu", action: :show_main_menu },
  ]

  STATIONS_MENU = [
    { id: "1", title: "Create a station", action: :create_station },
    { id: "2", title: "Show stations", action: :show_all_stations },
    { id: "3", title: "Show trains at the station", action: :show_trains_at_station },
    { id: "0", title: "Main menu", action: :show_main_menu },
  ]

  TRAINS_AND_CARRIAGES_MENU = [
    { id: "1", title: "Create a train", action: :create_train },
    { id: "2", title: "Show trains", action: :show_all_trains },
    { id: "3", title: "Create a carriage", action: :create_carriage },
    { id: "4", title: "Show carriages", action: :show_all_carriages },
    { id: "5", title: "Add a carriage to a train", action: :add_carriage_to_train },
    { id: "6", title: "Remove a carriage from a train", action: :remove_carriage_to_train },
    { id: "7", title: "Take up space or seats in the carriage", action: :take_up_space_or_seats_in_carriage },
    { id: "8", title: "Show list of train carriages ", action: :show_train_carriages },
    { id: "9", title: "Assign a train route", action: :assign_train_route },
    { id: "10", title: "Move the train to the next station", action: :move_train_to_next_station },
    { id: "11", title: "Move the train to the previous station", action: :move_train_to_previous_station },
    { id: "0", title: "Main menu", action: :show_main_menu },
  ]

  MAIN_MENU = [
    { id: "1", title: "Routes", action: :show_menu, params: ROUTES_MENU },
    { id: "2", title: "Stations", action: :show_menu, params: STATIONS_MENU },
    { id: "3", title: "Trains and Carriages", action: :show_menu, params: TRAINS_AND_CARRIAGES_MENU },
    { id: "4", title: "Seed", action: :seed },
    { id: "0", title: "Exit", action: :exit_program },
  ]

  def show_main_menu
    show_menu(MAIN_MENU)
  end

  def show_menu(menu)
    delimiter

    menu.each { |menu_item| puts "#{menu_item[:id]}. #{menu_item[:title]}" }

    choice = get_answer
    menu_processing(menu, choice)
  end

  def menu_processing(menu, choice)
    menu_item = menu.find { |menu_item| menu_item[:id] == choice }
    if menu_item && menu_item[:params]
      send(menu_item[:action], menu_item[:params])
    elsif menu_item
      send(menu_item[:action])
    else
      puts incorrect_choice
      show_menu(MAIN_MENU)
    end
  end

  def show_all_routes
    delimiter
    show_routes
    show_menu(ROUTES_MENU)
  end

  def show_all_stations
    delimiter
    show_stations
    show_menu(STATIONS_MENU)
  end

  def show_all_trains
    delimiter
    show_trains
    show_menu(TRAINS_AND_CARRIAGES_MENU)
  end

  def show_all_carriages
    delimiter
    show_carriages
    show_menu(TRAINS_AND_CARRIAGES_MENU)
  end

  def create_train
    delimiter
    puts "Create a train"
    train_type_index = select_type_of_carriage_of_train

    begin
      puts "Enter train number:"
      train_number = get_answer

      case train_type_index
      when 0
        trains << CargoTrain.new(train_number)
      when 1
        trains << PassengerTrain.new(train_number)
      end
      puts "Train created!"
    rescue RuntimeError => e
      puts e.message
      retry
    end

    show_menu(TRAINS_AND_CARRIAGES_MENU)
  end

  def show_trains
    return show_menu(TRAINS_AND_CARRIAGES_MENU) if trains_empty?

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

    begin
      puts "Enter carriage number:"
      carriage_number = get_answer

      case carriage_type_index
      when 0
        puts "Enter total space:"
        place = get_answer
        carriages << CargoCarriage.new(carriage_number, place)
      when 1
        puts "Enter the number of seats:"
        place = get_answer
        carriages << PassengerCarriage.new(carriage_number, place)
      end
      puts "Carriage created!"
    rescue RuntimeError => e
      puts e.message
      retry
    end

    show_menu(TRAINS_AND_CARRIAGES_MENU)
  end

  def show_carriages(carriagesArray = carriages)
    return show_menu(TRAINS_AND_CARRIAGES_MENU) if carriages_empty?

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
    return show_menu(TRAINS_AND_CARRIAGES_MENU) if array_of_carriages_by_type.empty?
    puts "Carriages:"

    show_carriages(array_of_carriages_by_type)
  end

  def add_carriage_to_train
    delimiter
    return show_menu(TRAINS_AND_CARRIAGES_MENU) if trains_empty? || carriages_empty?

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

    show_menu(TRAINS_AND_CARRIAGES_MENU)
  end

  def remove_carriage_to_train
    delimiter
    return show_menu(TRAINS_AND_CARRIAGES_MENU) if trains_empty? || carriages_empty?

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

    show_menu(TRAINS_AND_CARRIAGES_MENU)
  end

  def assign_train_route
    delimiter
    return show_menu(TRAINS_AND_CARRIAGES_MENU) if trains_empty? || routes_empty?

    train = select_train

    route_index = select_route_index

    train.route = routes[route_index]
    puts "The route has been assigned to the train!"

    show_menu(TRAINS_AND_CARRIAGES_MENU)
  end

  def move_train_to_next_station
    delimiter
    return show_menu(TRAINS_AND_CARRIAGES_MENU) if trains_empty? || routes_empty?

    train = select_train

    return show_menu(TRAINS_AND_CARRIAGES_MENU) if check_if_route_assigned_to_train?(train)

    if train.next_station
      train.move_to_next_station
      puts "The train has been move to the next station!"
    else
      puts "This is the last station!"
    end

    show_menu(TRAINS_AND_CARRIAGES_MENU)
  end

  def move_train_to_previous_station
    delimiter
    return show_menu(TRAINS_AND_CARRIAGES_MENU) if trains_empty? || routes_empty?

    train = select_train

    return show_menu(TRAINS_AND_CARRIAGES_MENU) if check_if_route_assigned_to_train?(train)

    if train.previous_station
      train.move_to_previous_station
      puts "The train has been move to the previous station!"
    else
      puts "This is the first station!"
    end

    show_menu(TRAINS_AND_CARRIAGES_MENU)
  end

  def create_station
    delimiter
    puts "Create a station"

    begin
      puts "Enter station name:"
      station_name = get_answer

      stations << Station.new(station_name)
      puts "Station created!"
    rescue RuntimeError => e
      puts e.message
      retry
    end

    show_menu(STATIONS_MENU)
  end

  def show_stations
    return show_menu(STATIONS_MENU) if stations_empty?

    puts "Stations:"
    stations.each_with_index do |station, index|
      puts "#{index}. #{station.name}"
    end
  end

  def show_list_of_train_carriages(train)
    train.each_carriage do |carriage|
      puts "Carriage number: #{carriage.number}, " \
           "type: #{carriage.type}, " \
           "free place: #{carriage.free_place}, " \
           "occupied place: #{carriage.used_place}"
    end
  end

  def show_trains_at_station
    delimiter
    return show_menu(STATIONS_MENU) if stations_empty?

    stations.each_with_index do |station, index|
      delimiter if index != 0
      puts "Station name: #{station.name}"
      if station.trains.empty?
        puts "No trains!"
      else
        station.each_train do |train|
          puts "Train number: #{train.number}, type: #{train.type}, number of carriages: #{train.carriages.length}"
          show_list_of_train_carriages(train)
        end
      end
    end

    show_menu(STATIONS_MENU)
  end

  def show_train_carriages
    delimiter
    return show_menu(TRAINS_AND_CARRIAGES_MENU) if trains_empty?

    show_trains
    puts "Select the index of the trains:"
    train_type_index = check_index_is_correct(trains.length)
    train = trains[train_type_index]

    return puts "The selected train has no carriages!" if train.carriages.empty?
    show_list_of_train_carriages(train)

    show_menu(TRAINS_AND_CARRIAGES_MENU)
  end

  def create_route
    delimiter
    return show_menu(ROUTES_MENU) if stations_empty?

    puts "Create a route:"
    show_stations

    puts "Select the index of the first station:"
    first_station_index = check_index_is_correct(stations.length)

    puts "Select the index of the last station:"
    last_station_index = check_index_is_correct(stations.length)

    routes << Route.new(stations[first_station_index], stations[last_station_index])
    puts "Route created!"
    show_menu(ROUTES_MENU)
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
    return show_menu(ROUTES_MENU) if stations_empty? || routes_empty?

    route_index = select_route_index

    show_stations
    puts "Select station index:"
    station_index = check_index_is_correct(stations.length)

    routes[route_index].add_station(stations[station_index])
    puts "The station has been added to the route!"
    show_menu(ROUTES_MENU)
  end

  def remove_station_from_route
    delimiter
    return show_menu(ROUTES_MENU) if stations_empty? || routes_empty?

    route_index = select_route_index

    stations_of_route = routes[route_index].stations

    if stations_of_route.length < 3
      puts "You can't remove the first and last station!"
      return show_menu(ROUTES_MENU)
    end

    puts "Stations:"
    stations_of_route.each_with_index do |station, index|
      puts "#{index}. #{station.name}"
    end

    puts "Select station index:"
    station_index = check_index_is_correct(stations_of_route.length)

    routes[route_index].remove_station(stations_of_route[station_index])
    puts "The station has been removed to the route!"
    show_menu(ROUTES_MENU)
  end

  def take_up_space_or_seats_in_carriage
    delimiter
    return show_menu(TRAINS_AND_CARRIAGES_MENU) if carriages_empty?

    show_carriages
    puts "Select carriage index:"
    carriage_index = check_index_is_correct(carriages.length)

    carriage = carriages[carriage_index]

    if carriage.type == :passenger
      carriage.take_place
      puts "The seat was occupied"
    else
      puts "Enter space:"
      space = get_answer_i
      carriage.take_place(space)
      puts "The space was occupied"
    end

    show_menu(TRAINS_AND_CARRIAGES_MENU)
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

  def exit_program
    Kernel.exit
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

  def seed
    5.times do |i|
      stations << Station.new("#{i}000#{rand(10..99)}")
    end

    5.times do
      routes << Route.new(stations[rand(0..4)], stations[rand(0..4)])
    end

    routes.each do |route|
      route.add_station(stations[rand(0..4)])
    end

    5.times do |i|
      trains << CargoTrain.new("#{i}C0")
      trains << PassengerTrain.new("#{i}P0")
    end

    trains.each do |train|
      train.route = routes[rand(0..4)]
      if train.type == :passenger
        3.times do |i|
          passenger_carriage = PassengerCarriage.new("#{i}P00#{rand(10..99)}", rand(1..10))
          train.add_carriage(passenger_carriage)
          carriages << passenger_carriage
        end
      else
        3.times do |i|
          cargo_carriage = CargoCarriage.new("#{i}C00#{rand(10..99)}", rand(10..100))
          train.add_carriage(cargo_carriage)
          carriages << cargo_carriage
        end
      end
    end

    show_main_menu
  end
end
