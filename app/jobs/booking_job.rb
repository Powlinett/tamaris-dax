class BookingJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    #send booking confirmation email.
  end
end
