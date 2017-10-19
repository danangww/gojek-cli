# TODO: Complete Order class
require 'json'
require 'date'

module GoCLI
  class Order
    attr_accessor :timestamp, :origin, :destination, :origin_coord, :destination_coord, :est_price, :driver, :type

    # TODO: 
    # 1. Add two instance variables: name and email 
    # 2. Write all necessary changes, including in other files
    def initialize(opts = {})
      @timestamp = Time.new
      @origin = opts[:origin] || ''
      @destination = opts[:destination] || ''
      @origin_coord = opts[:origin_coord] || 0
      @destination_coord = opts[:destination_coord] || 0
      @est_price = opts[:type] == 'gojek' ? opts[:est_price_gojek] : opts[:est_price_gocar]
      @driver = opts[:driver] || ''
      @type = opts[:type] || ''
    end

    def self.load
      return nil unless File.file?("#{File.expand_path(File.dirname(__FILE__))}/../../data/orders.json")

      file = File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/orders.json")
      data = JSON.parse(file)

      data
    end

    def save!
      # TODO: Add validation before writing user data to file
      data = Order.load
      order = {timestamp: @timestamp, origin: @origin, destination: @destination, est_price: @est_price, driver: @driver, type: @type}
      data << order
      File.open("#{File.expand_path(File.dirname(__FILE__))}/../../data/orders.json", "w") do |f|
        f.write JSON.pretty_generate(data)
      end

      #update driver location
      update_driver_location
    end

    def update_driver_location
      data = []
      Order.load_fleet.each do |hash|
        driver = {driver: hash['driver'], type: hash['type'], location: (hash['driver'] == @driver) ? @destination_coord : hash['location']}
        data << driver
      end

      File.open("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleet_locations.json", "w") do |f|
        f.write JSON.pretty_generate(data)
      end
    end

    def self.load_fleet
      return nil unless File.file?("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleet_locations.json")

      file = File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/fleet_locations.json")
      data = JSON.parse(file)

      data
    end

    def self.check_fleet(opts = {})
      form = opts
      driver = []
      load_fleet.each do |hash|
        hash['distance'] = Location.length(hash['location'], form[:origin_coord])
        driver << hash if hash['distance'] <= 1.0 && hash['type'] == form[:type]
      end

      driver.sort_by! { |hash| hash['distance'] }      
    end
  end
end
