# frozen_string_literal: true

require 'json'
require 'date'

module GoCLI
  # Order class for accessing, checking, and writing to orders.json file containing user orders history
  class Order
    attr_accessor :timestamp, :origin, :destination, :ori_coord, :dest_coord, :est_price, :driver, :type, :payment_method

    def initialize(opts = {})
      @timestamp = Time.new
      @origin = opts[:origin]
      @destination = opts[:destination]
      @ori_coord = opts[:ori_coord]
      @dest_coord = opts[:dest_coord]
      @est_price = opts[:est_price]
      @driver = opts[:driver]
      @type = opts[:type]
      @payment_method = opts[:payment_method]
    end

    def self.load
      return nil unless File.file?("#{File.expand_path(__dir__)}/../../data/orders.json")

      file = File.read("#{File.expand_path(__dir__)}/../../data/orders.json")
      data = JSON.parse(file)

      data
    end

    def save!
      data = Order.load
      order = { timestamp: @timestamp, origin: @origin, destination: @destination, est_price: @est_price, driver: @driver, type: @type, payment_method: @payment_method }
      data << order
      File.open("#{File.expand_path(__dir__)}/../../data/orders.json", 'w') do |f|
        f.write JSON.pretty_generate(data)
      end
      
      # update driver location
      update_driver_location
    end

    def update_driver_location
      data = []
      Order.load_fleet.each do |hash|
        driver = { driver: hash['driver'], type: hash['type'], location: hash['driver'] == @driver ? @dest_coord : hash['location'] }
        data << driver
      end

      File.open("#{File.expand_path(__dir__)}/../../data/fleet_locations.json", 'w') do |f|
        f.write JSON.pretty_generate(data)
      end
    end

    def self.load_fleet
      return nil unless File.file?("#{File.expand_path(__dir__)}/../../data/fleet_locations.json")

      file = File.read("#{File.expand_path(__dir__)}/../../data/fleet_locations.json")
      data = JSON.parse(file)

      data
    end

    def self.check_fleet(opts = {})
      form = opts
      driver = []
      load_fleet.each do |hash|
        hash['distance'] = Location.length(hash['location'], form[:ori_coord])
        driver << hash if hash['distance'] <= 1.0 && hash['type'] == form[:type]
      end

      driver.sort_by! { |hash| hash['distance'] }
    end
  end
end
