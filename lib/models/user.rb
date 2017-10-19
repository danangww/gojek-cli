require 'json'

module GoCLI
  class User
    attr_accessor :name, :email, :phone, :password, :gopay

    # TODO: 
    # 1. Add two instance variables: name and email 
    # 2. Write all necessary changes, including in other files
    def initialize(opts = {})
      @name = opts[:name] || ''
      @email = opts[:email] || ''
      @phone = opts[:phone] || ''
      @password = opts[:password] || ''
      @gopay = 0
    end

    def self.load
      return nil unless File.file?("#{File.expand_path(File.dirname(__FILE__))}/../../data/user.json")

      file = File.read("#{File.expand_path(File.dirname(__FILE__))}/../../data/user.json")
      data = JSON.parse(file)

      self.new(
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
      if form[:name].empty?
        errors += "Field name is required\n"
      end
      if form[:email].empty?
        errors += "Field email is required\n"
      end
      if form[:phone].empty?
        errors += "Field phone is required\n"
      end
      if form[:password].empty?
        errors += "Field password is required\n"
      end
      if ( form[:email] =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i ) == nil 
        errors += "Field email is not valid\n"
      end
      if ( form[:phone] =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/ ) == nil 
        errors += "Field phone is not valid\n"
      end
      
      errors
    end

    def self.validate_topup(opts = {})
      form = opts
      errors = ''
      if form[:gopay_topup].empty?
        errors += "Field amount is required\n"
      end
      if ( form[:gopay_topup] =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/ ) == nil 
        errors += "Field amount is not valid\n"
      end
      
      errors
    end

    def save!
      # TODO: Add validation before writing user data to file
      user = {name: @name, email: @email, phone: @phone, password: @password, gopay: @gopay}
      File.open("#{File.expand_path(File.dirname(__FILE__))}/../../data/user.json", "w") do |f|
        f.write JSON.generate(user)
      end
    end
  end
end
