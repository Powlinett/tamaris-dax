desc "check if bookings aren't closed"
task :check_bookings => :environment do
  puts "Check bookings..."
  Booking.where(actual_state: ['pending', 'confirmed'])
         .each(&:booking_closed?)
  puts "Bookings had been checked."
end
