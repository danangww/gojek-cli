# frozen_string_literal: true

require 'json'
require 'date'

module GoCLI
  # Location class for accessing, checking, and writing to location.json file
  class Location
    def self.load
      return nil unless File.file?("#{File.expand_path(__dir__)}/../../data/locations.json")

      file = File.read("#{File.expand_path(__dir__)}/../../data/locations.json")
      data = JSON.parse(file)

      data
    end

    def self.check(opts = {})
      form = opts
      form.delete(:ori_coord) if form.key? :ori_coord
      form.delete(:dest_coord) if form.key? :dest_coord

      load.each do |hash|
        form[:ori_coord] = hash['coord'] if hash['name'] == form[:origin]
        form[:dest_coord] = hash['coord'] if hash['name'] == form[:destination]
      end

      (form.key? :ori_coord) && (form.key? :dest_coord) && form[:origin] != form[:destination]
    end

    def self.length(ori, dest)
      Math.sqrt((dest[0] - ori[0])**2 + (dest[1] - ori[1])**2)
    end
  end
end
