require 'test_helper'

class BookingMailerTest < ActionMailer::TestCase
  test "booking_registration" do
    mail = BookingMailer.booking_registration
    assert_equal "Booking registration", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
