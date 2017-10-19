# TODO: Complete Location class
require 'json'
require 'date'

module GoCLI
  class Point
    attr_accessor :x, :y
    def initialize(arr)
      @x = arr[0]
      @y = arr[1]
    end
  end

  class Location
    attr_accessor :name, :coord

    def initialize(opts = {})
      @name = opts[:location_name] || ''
      @coord = opts[:location_coord] || []
    end

    def self.load
      return nil unless File.file?("#{File.expand_path(File.dirname(__FILE__))}/../../data/locations.json")

      file = File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/locations.json")
      data = JSON.parse(file)

      data
    end

    def self.check(opts = {})
      form = opts
      form.delete(:origin_coord)
      form.delete(:destination_coord)

      load.each do |hash|
        form[:origin_coord] = hash['coord'] if hash['name'] == form[:origin]
        form[:destination_coord] = hash['coord'] if hash['name'] == form[:destination]
      end

      (form.has_key? :origin_coord) && (form.has_key? :destination_coord)
    end

    def self.length(origin, destination)
      Math.sqrt((destination[0] - origin[0])**2 + (destination[1] - origin[1])**2)
    end
  end
end
