# Preview all emails at http://localhost:3000/rails/mailers/booking_mailer
class BookingMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/booking_mailer/registration
  def registration
    booking = Booking.last
    BookingMailer.with(booking: booking).registration
  end

  def confirmation
    booking = Booking.where(actual_state: 'confirmed').last
    BookingMailer.with(booking: booking).confirmation
  end

  def cancel
    booking = Booking.where(actual_state: 'canceled').last
    BookingMailer.with(booking: booking).cancel
  end
end
