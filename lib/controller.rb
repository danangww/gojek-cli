# frozen_string_literal: true

require_relative './models/user'
require_relative './models/order'
require_relative './models/location'
require_relative './view'

module GoCLI
  # Controller is a class that call corresponding models and methods for every action
  class Controller
    # This is an example how to create a registration method for your controller
    def registration(opts = {})
      # First, we clear everything from the screen
      clear_screen(opts)
      # Second, we call our View and its class method called "registration"
      # Take a look at View class to see what this actually does
      form = View.registration(opts)
      # This is the main logic of this method:
      # - passing input form to an instance of User class (named "user")
      # - invoke ".save!" method to user object
      # TODO: enable saving name and email
      valid_msg = User.validate(form)
      if !valid_msg.empty?
        form[:flash_msg] = valid_msg
        registration(form)
      else
        user = User.new(
          name:    form[:name],
          email:    form[:email],
          phone:    form[:phone],
          password: form[:password],
          gopay:    form[:gopay]
        )
        user.save!
        # Assigning form[:user] with user object
        form[:user] = user
      end
      # Returning the form
      form
    end

    def login(opts = {})
      halt = false
      until halt
        clear_screen(opts)
        form = View.login(opts)
        # Check if user inputs the correct credentials in the login form
        if credential_match?(form[:user], form[:login], form[:password])
          halt = true
        else
          form[:flash_msg] = 'Credentials doesn\'t match. Please try again'
        end
      end
      form
    end

    def main_menu(opts = {})
      clear_screen(opts)
      form = View.main_menu(opts)

      case form[:steps].last[:option].to_i
      when 1
        # Step 4.1
        view_profile(form)
      when 2
        # Step 4.2
        order_goride(form)
      when 3
        # Step 4.3
        view_order_history(form)
      when 4
        view_gopay(form)
      when 5
        exit(true)
      else
        form[:flash_msg] = 'Wrong option entered, please retry.'
        main_menu(form)
      end
    end

    def view_profile(opts = {})
      clear_screen(opts)
      form = View.view_profile(opts)

      case form[:steps].last[:option].to_i
      when 1
        edit_profile(form)
      when 2
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry.'
        view_profile(form)
      end
    end

    # This will be invoked when user choose Edit Profile menu in view_profile screen
    def edit_profile(opts = {})
      clear_screen(opts)
      form = View.edit_profile(opts)

      case form[:steps].last[:option].to_i
      when 1
        valid_msg = User.validate(form)
        if !valid_msg.empty?
          form[:flash_msg] = valid_msg
          edit_profile(form)
        else
          user = User.new(
            name:    form[:name],
            email:    form[:email],
            phone:    form[:phone],
            password: form[:password]
          )
          user.save!
          # Assigning form[:user] with user object
          form[:user] = user
          form[:flash_msg] = 'Your profile has been updated.'
        end
      when 2
        form[:flash_msg] = 'You canceled your profile changes.'
      else
        form[:flash_msg] = 'Wrong option entered, please retry.'
        edit_profile(form)
      end

      view_profile(form)
    end

    # TODO: Complete order_goride method
    def order_goride(opts = {})
      clear_screen(opts)
      form = View.order_goride(opts)

      if Location.check(form)
        order_goride_confirm(form)
      else
        form[:flash_msg] = 'Sorry, the route is unavailable. Please try again.'
        main_menu(form)
      end
    end

    # TODO: Complete order_goride_confirm method
    # This will be invoked after user finishes inputting data in order_goride method
    def order_goride_confirm(opts = {})
      clear_screen(opts)
      form = opts
      form[:length] = Location.length(form[:ori_coord], form[:dest_coord])
      form[:est_price_gojek] = (form[:length] * 1500).round
      form[:est_price_gocar] = (form[:length] * 2500).round

      form = View.order_goride_confirm(form)

      case form[:steps].last[:option].to_i
      when 1
        form[:type] = 'gojek'
        form[:est_price] = opts[:est_price_gojek]

        drivers = Order.check_fleet(form)
        # p drivers.first
        if !drivers.empty?
          form[:driver] = drivers.first['driver']
          form[:flash_msg] = 'Yeay, there are gojek drivers around you! Please choose payment method.'
          
          order_payment_confirm(form)
        else
          form[:flash_msg] = 'Sorry, we can not find you a gojek driver. You may try using gocar.'
          order_get_no_driver(form)
        end
      when 2
        form[:type] = 'gocar'
        form[:est_price] = opts[:est_price_gocar]

        drivers = Order.check_fleet(form)
        # p drivers.first
        if !drivers.empty?
          form[:driver] = drivers.first['driver']
          form[:flash_msg] = 'Yeay, there are gocar drivers around you! Please choose payment method.'
          
          order_payment_confirm(form)
        else
          form[:flash_msg] = 'Sorry, we can not find you a gojek driver. You may try using gocar.'
          order_get_no_driver(form)
        end
      when 3
        order_goride(form)
      when 4
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry.'
        order_goride_confirm(form)
      end
    end

    def order_get_no_driver(opts = {})
      clear_screen(opts)
      form = opts
      form = View.order_get_no_driver(form)

      case form[:steps].last[:option].to_i
      when 1
        order_goride(form)
      when 2
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry.'
        order_get_no_driver(form)
      end
    end

    def order_payment_confirm(opts = {})
      clear_screen(opts)
      form = opts
      form = View.order_payment_confirm(form)

      case form[:steps].last[:option].to_i
      when 1 # gopay
        form[:payment_method] = 'gopay'

        if form[:user].gopay < form[:est_price]
          form[:flash_msg] = "You GoPay balance is not enough."
          order_payment_confirm(form)
        end
      when 2 # cash
        form[:payment_method] = 'cash'
      when 3
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry.'
        order_payment_confirm(form)
      end

      # save order
      order = Order.new(form)
      order.save!
      if form[:payment_method] == 'gopay'
        user = User.load
        user.debet_gopay(form[:est_price])
        user.save!
        form[:user] = user
      end
      form[:flash_msg] = "You order has been saved. Wait for #{form[:driver]} to pick you up."
      main_menu(form)
    end

    def view_order_history(opts = {})
      clear_screen(opts)
      form = View.view_order_history(opts)

      case form[:steps].last[:option].to_i
      when 1
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry.'
        view_order_history(form)
      end
    end

    def view_gopay(opts = {})
      clear_screen(opts)
      form = View.view_gopay(opts)

      case form[:steps].last[:option].to_i
      when 1
        top_up_gopay(form)
      when 2
        main_menu(form)
      else
        form[:flash_msg] = "Wrong option entered, please retry."
        view_gopay(form)
      end
    end

    def top_up_gopay(opts = {})
      clear_screen(opts)
      form = View.top_up_gopay(opts)

      case form[:steps].last[:option].to_i
      when 1
        valid_msg = User.validate_topup(form)
        if !valid_msg.empty?
          form[:flash_msg] = valid_msg
        else
          user = User.load
          user.topup_gopay(form[:gopay_topup])
          user.save!
          form[:user] = user
          form.delete(:gopay_topup)
          form[:flash_msg] = 'Top Up GoPay success!'
        end
        view_gopay(form)
      when 2
        form.delete(:gopay_topup)
        main_menu(form)
      else
        form[:flash_msg] = 'Wrong option entered, please retry.'
        top_up_gopay(form)
      end
    end

    protected

    # You don't need to modify this
    def clear_screen(opts = {})
      Gem.win_platform? ? (system 'cls') : (system 'clear')
      return false unless opts[:flash_msg]
      puts opts[:flash_msg]
      puts ''
      opts[:flash_msg] = nil
    end

    # TODO: credential matching with email or phone
    def credential_match?(user, login, password)
      return false unless user.phone == login || user.email == login
      return false unless user.password == password
      true
    end
  end
end
