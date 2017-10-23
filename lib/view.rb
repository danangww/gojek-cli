# frozen_string_literal: true

module GoCLI
  # View is a class that show menus and forms to the screen
  class View
    # This is a class method called ".registration"
    # It receives one argument, opts with default value of empty hash
    # TODO: prompt user to input name and email
    def self.registration(opts = {})
      form = opts

      puts 'Registration'
      puts ''

      print 'Your name: '
      form[:name] = gets.chomp

      print 'Your email: '
      form[:email] = gets.chomp

      print 'Your phone: '
      form[:phone] = gets.chomp

      print 'Your password: '
      form[:password] = gets.chomp

      form[:steps] << { id: __method__ }

      form
    end

    def self.login(opts = {})
      form = opts

      puts 'Login'
      puts ''

      print 'Enter your email/phone: '
      form[:login] = gets.chomp

      print 'Enter your password: '
      form[:password] = gets.chomp

      form[:steps] << { id: __method__ }

      form
    end

    def self.main_menu(opts = {})
      form = opts

      puts 'Welcome to Go-CLI!'
      puts ''

      puts 'Main Menu'
      puts '1. View Profile'
      puts '2. Order Go-Ride'
      puts '3. View Order History'
      puts '4. Your GoPay'
      puts '5. Go-Ride Promo'
      puts '6. Exit'

      print 'Enter your option: '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    # TODO: Complete view_profile method
    def self.view_profile(opts = {})
      form = opts

      puts 'View Profile'
      puts ''

      # Show user data here
      puts "Name \t\t: #{form[:user].name}"
      puts "Email \t\t: #{form[:user].email}"
      puts "Phone \t\t: #{form[:user].phone}"
      puts "Password \t: #{form[:user].password}\n\n"

      puts '1. Edit Profile'
      puts '2. Back'

      print 'Enter your option: '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    # TODO: Complete edit_profile method
    # This is invoked if user chooses Edit Profile menu when viewing profile
    def self.edit_profile(opts = {})
      form = opts

      puts 'Edit Profile'
      puts ''

      print 'Your name: '
      form[:name] = gets.chomp

      print 'Your email: '
      form[:email] = gets.chomp

      print 'Your phone: '
      form[:phone] = gets.chomp

      print 'Your password: '
      form[:password] = gets.chomp

      puts "\n\n1. Save"
      puts '2. Discard'

      print 'Enter your option: '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    # TODO: Complete order_goride method
    def self.order_goride(opts = {})
      form = opts

      puts 'Order GoRide'
      puts ''
      locations = []
      Location.load.each { |hash| locations << hash['name'] }
      puts "Available route : #{locations.join(' - ')}"
      puts ''

      print 'Your position: '
      form[:origin] = gets.chomp.downcase

      print 'Your destination: '
      form[:destination] = gets.chomp.downcase

      form[:steps] << { id: __method__ }

      form
    end

    # TODO: Complete order_goride_confirm method
    # This is invoked after user finishes inputting data in order_goride method
    def self.order_goride_confirm(opts = {})
      form = opts

      puts 'Order Confirmation'
      puts ''

      print "Origin \t\t: #{form[:origin]}\n"
      print "Destination \t: #{form[:destination]}\n"
      print "Route Length \t: #{form[:length]}\n"
      print "Gojek Price \t: #{form[:est_price_gojek]}\n"
      print "Gocar Price \t: #{form[:est_price_gocar]}\n"

      if form.key? :discount
        print "\nPromo Code \t\t: #{form[:promo_code]}\n"
        print "Promo Type \t\t: #{form[:promo_type]}\n"
        print "Promo Value \t\t: #{form[:promo_value]} #{form[:promo_type] == 'percentage' ? '%' : ''}\n"
        print "Gojek Promo Price \t: #{form[:promo_gojek]}\n"
        print "Gocar Promo Price \t: #{form[:promo_gocar]}\n"
      end

      puts "\n1. Order Gojek (Harga : #{(form.key? :promo_gojek) ? form[:promo_gojek] : form[:est_price_gojek]})"
      puts "2. Order Gocar (Harga : #{(form.key? :promo_gocar) ? form[:promo_gocar] : form[:est_price_gocar]})"
      puts '3. Insert Promo / Voucher Code'
      puts '4. Back to Choose Route'
      puts '5. Back to Main Menu'

      print 'Enter your option: '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    def self.order_get_no_driver(opts = {})
      form = opts

      puts 'Order Cancelled'
      puts ''

      print "Origin \t\t: #{form[:origin]}\n"
      print "Destination \t: #{form[:destination]}\n"
      print "Route Length \t: #{form[:length]}\n"
      print "Gojek Price \t: #{form[:est_price_gojek]}\n"
      print "Gocar Price \t: #{form[:est_price_gocar]}\n\n"

      if form.key? :discount
        print "\nPromo Code \t\t: #{form[:promo_code]}\n"
        print "Promo Type \t\t: #{form[:promo_type]}\n"
        print "Promo Value \t\t: #{form[:promo_value]} #{form[:promo_type] == 'percentage' ? '%' : ''}\n"
        print "Gojek Promo Price \t: #{form[:promo_gojek]}\n"
        print "Gocar Promo Price \t: #{form[:promo_gocar]}\n"
      end

      puts "\n1. Back to Choose Route"
      puts '2. Back to Main Menu'

      print 'Enter your option: '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    def self.order_payment_confirm(opts = {})
      form = opts

      puts 'Order Payment Confirmation'
      puts ''

      print "Origin \t\t: #{form[:origin]}\n"
      print "Destination \t: #{form[:destination]}\n"
      print "Route Length \t: #{form[:length]}\n"
      print "Fleet Type \t: #{form[:type]}\n"
      print "Price \t\t: #{form[:est_price]}\n\n"

      puts "1. Via GoPay (Balance : #{form[:user].gopay})"
      puts "2. Cash"
      puts '3. Cancel Order'

      print 'Enter your option: '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    def self.order_promo(opts = {})
      form = opts

      puts 'Promo / Voucher Code'
      puts ''

      print 'Promo code: '
      form[:promo_code] = gets.chomp

      form[:steps] << { id: __method__ }

      form
    end

    # TODO: Complete view_order_history method
    def self.view_order_history(opts = {})
      form = opts

      puts 'View Order History'
      puts ''

      Order.load.each_with_index do |order, index|
        puts "##{index + 1}"
        puts "Timestamp \t: #{order['timestamp']}"
        puts "Origin \t\t: #{order['origin']}"
        puts "Destination \t: #{order['destination']}"
        puts "Price \t\t: #{order['est_price']}"
        puts "Promo Code \t: #{order['promo_code']}"
        puts "Discount \t: #{order['discount']}"
        puts "Payment \t: #{order['payment_method']}"
        puts "Fleet Type\t: #{order['type']}"
        puts "Driver \t\t: #{order['driver']}\n\n"
      end

      puts "\n1. Back"

      print 'Enter your option: '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    def self.view_promo(opts = {})
      form = opts

      puts 'View Promo'
      puts ''

      Promo.load.each_with_index do |promo, index|
        puts "##{index + 1}"
        puts "Code \t: #{promo['code']}"
        puts "Type \t: #{promo['type']}"
        puts "Value \t: #{promo['value']}#{(promo['type'] == 'percentage') ? '%' : ''}\n\n"
      end

      puts "\n1. Back"

      print 'Enter your option: '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    def self.view_gopay(opts = {})
      form = opts

      puts 'View GoPay'
      puts ''

      print "GoPay Balance \t: #{form[:user].gopay}\n\n"

      puts "\n1. Top Up"
      puts '2. Back to Main Menu'

      print 'Enter your option: '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end

    def self.top_up_gopay(opts = {})
      form = opts

      puts 'Top Up GoPay'
      puts ''

      print "GoPay Balance \t: #{form[:user].gopay}\n\n"

      print 'Enter amount : '
      form[:gopay_topup] = gets.chomp
      puts "\n1. Submit"
      puts '2. Cancel'

      print 'Enter your option: '
      form[:steps] << { id: __method__, option: gets.chomp }

      form
    end
  end
end
