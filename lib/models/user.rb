# frozen_string_literal: true

require 'json'

module GoCLI
  EMAIL_VALID_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  NUMBER_VALID_REGEX = /\A[-+]?[0-9]*\.?[0-9]+\Z/
  # User class for user data management
  class User
    attr_accessor :name, :email, :phone, :password, :gopay

    def initialize(opts = {})
      @name = opts[:name] || ''
      @email = opts[:email] || ''
      @phone = opts[:phone] || ''
      @password = opts[:password] || ''
      @gopay = opts[:gopay] || 0
    end

    def self.load
      return nil unless File.file?("#{File.expand_path(__dir__)}/../../data/user.json")

      file = File.read("#{File.expand_path(__dir__)}/../../data/user.json")
      data = JSON.parse(file)
      new(
        name:     data['name'],
        email:    data['email'],
        phone:    data['phone'],
        password: data['password'],
        gopay:    data['gopay']
      )
    end

    def topup_gopay(amount)
      @gopay += amount.to_i
    end

    # TODO: Add your validation method here
    def self.validate(opts = {})
      form = opts
      errors = ''
      errors += "Field name is required\n" if form[:name].empty?
      errors += "Field email is required\n" if form[:email].empty?
      errors += "Field phone is required\n" if form[:phone].empty?
      errors += "Field password is required\n" if form[:password].empty?
      errors += "Field email is not valid\n" if (form[:email] =~ EMAIL_VALID_REGEX).nil?
      errors += "Field phone is not valid\n" if (form[:phone] =~ NUMBER_VALID_REGEX).nil?
      errors
    end

    def self.validate_topup(opts = {})
      form = opts
      errors = ''
      errors += "Field amount is required\n" if form[:gopay_topup].empty?
      errors += "Field amount is not valid\n" if (form[:gopay_topup] =~ NUMBER_VALID_REGEX).nil?
      errors
    end

    def save!
      # TODO: Add validation before writing user data to file
      user = { name: @name, email: @email, phone: @phone, password: @password, gopay: @gopay }
      File.open("#{File.expand_path(__dir__)}/../../data/user.json", 'w') do |f|
        f.write JSON.generate(user)
      end
    end
  end
end
