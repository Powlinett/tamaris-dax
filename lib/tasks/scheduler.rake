desc "check if bookings aren't closed"
task :check_bookings => :environment do
  puts "Check if bookings dates are passed"
  Booking.where(actual_state: ['pending', 'confirmed']).each do |booking|
    booking.save if booking.is_closed?
  end
  puts "Bookings had been checked."
end
