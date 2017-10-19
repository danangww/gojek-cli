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

      form[:steps] << {id: __method__}

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

      form[:steps] << {id: __method__}

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
      puts '5. Exit'

      print 'Enter your option: '
      form[:steps] << {id: __method__, option: gets.chomp}

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
      form[:steps] << {id: __method__, option: gets.chomp}

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

      puts "\n\n1. Simpan"
      puts '2. Batal'

      print 'Enter your option: '
      form[:steps] << {id: __method__, option: gets.chomp}

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
      form[:origin] = gets.chomp

      print 'Your destination: '
      form[:destination] = gets.chomp

      form
    end

    # TODO: Complete order_goride_confirm method
    # This is invoked after user finishes inputting data in order_goride method
    def self.order_goride_confirm(opts = {})
      form = opts

      puts 'Order Confirmation'
      puts ''

      print "Asal \t\t: #{form[:origin]}\n"
      print "Tujuan \t\t: #{form[:destination]}\n"
      print "Panjang Rute \t: #{form[:length]}\n"
      print "Harga Gojek \t: #{form[:est_price_gojek]}\n"
      print "Harga Gocar \t: #{form[:est_price_gocar]}\n\n"

      puts "1. Pesan Gojek (Harga : #{form[:est_price_gojek]})"
      puts "2. Pesan Gocar (Harga : #{form[:est_price_gocar]})"
      puts '3. Ulangi'
      puts '4. Kembali ke menu awal'

      print 'Enter your option: '
      form[:steps] << {id: __method__, option: gets.chomp}

      form
    end

    def self.order_get_no_driver(opts = {})
      form = opts

      puts 'Order Cancelled'
      puts ''

      print "Asal \t\t: #{form[:origin]}\n"
      print "Tujuan \t\t: #{form[:destination]}\n"
      print "Panjang Rute \t: #{form[:length]}\n"
      print "Harga Gojek \t: #{form[:est_price_gojek]}\n"
      print "Harga Gocar \t: #{form[:est_price_gocar]}\n\n"

      puts '1. Ulangi Pemilihan Rute'
      puts '2. Kembali ke menu awal'

      print 'Enter your option: '
      form[:steps] << {id: __method__, option: gets.chomp}

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
        puts "Asal \t\t: #{order['origin']}"
        puts "Tujuan \t\t: #{order['destination']}"
        puts "Harga \t\t: #{order['est_price']}"
        puts "Armada \t\t: #{order['type']}"
        puts "Driver \t\t: #{order['driver']}\n\n"
      end

      puts "\n1. Back"

      print 'Enter your option: '
      form[:steps] << {id: __method__, option: gets.chomp}

      form
    end

    def self.view_gopay(opts = {})
      form = opts

      puts 'View GoPay'
      puts ''

      print "GoPay Balance \t: #{form[:user].gopay}\n\n"

      puts "\n1. Top Up"
      puts '2. Kembali ke menu utama'

      print 'Enter your option: '
      form[:steps] << {id: __method__, option: gets.chomp}

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
      puts '2. Batal'

      print 'Enter your option: '
      form[:steps] << {id: __method__, option: gets.chomp}

      form
    end
  end
end
