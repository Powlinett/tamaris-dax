require 'test_helper'

class BookingMailerTest < ActionMailer::TestCase
  test "registration" do
    mail = BookingMailer.registration
    assert_equal "Registration", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
