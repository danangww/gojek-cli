# frozen_string_literal: true

require 'json'
require 'date'

module GoCLI
  # Location class for accessing, checking, and writing to location.json file
  class Promo
    def self.load
      return nil unless File.file?("#{File.expand_path(__dir__)}/../../data/promos.json")

      file = File.read("#{File.expand_path(__dir__)}/../../data/promos.json")
      data = JSON.parse(file)

      data
    end

    def self.check(opts = {})
      form = opts
      form.delete(:promo_type) if form.key? :promo_type
      form.delete(:promo_value) if form.key? :promo_value
      found = false
      load.each do |hash|
        if hash['code'] == form[:promo_code]
          form[:promo_type] = hash['type']
          form[:promo_value] = hash['value']
          found = true
          break
        end
      end

      if !found
        form = reset(form)
      end

      form
    end

    def self.reset(opts = {})
      form = opts
      form.delete(:promo_code) if form.key? :promo_code
      form.delete(:promo_type) if form.key? :promo_type
      form.delete(:promo_value) if form.key? :promo_value
      form.delete(:promo_gojek) if form.key? :promo_gojek
      form.delete(:promo_gocar) if form.key? :promo_gocar
      form.delete(:discount) if form.key? :discount
      form
    end
  end
end
