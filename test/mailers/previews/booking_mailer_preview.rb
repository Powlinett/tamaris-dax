# Preview all emails at http://localhost:3000/rails/mailers/booking_mailer
class BookingMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer/booking_registration
  def booking_registration
    booking = Booking.last
    BookingMailer.with(booking_id: booking.id).booking_registration
  end
end
