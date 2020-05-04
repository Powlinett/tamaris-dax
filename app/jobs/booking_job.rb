class BookingJob < ApplicationJob
  queue_as :default

  def perform(*args)
    #send booking confirmation email.
  end
end
