desc "check if bookings aren't closed"
task check_bookings: :environment do
  puts "Check if bookings dates are passed"
  Booking.where(actual_state: ['pending', 'confirmed']).each do |booking|
    booking.save if booking.is_closed?
  end
  puts "Bookings had been checked."
end

desc "check if product's price has changed"
task check_prices: :environment do
  puts "Check the prices on tamaris.com"
  Product.all.each do |product|
    CheckProductPriceJob.perform_later(product)
  end
end
