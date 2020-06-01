require 'rails_helper'

describe Booker do
  it { should have_many :bookings }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }

  it { should validate_presence_of :email }
  it { should validate_confirmation_of(:email) }
  it { should allow_value('johndoe@test.com').for(:email) }
  it { should_not allow_value('<,;:!741@esc.com').for(:email)}
  it { should validate_presence_of :email_confirmation }

  it { should validate_presence_of :phone_number }
  it { should allow_value('0612345789').for(:phone_number) }
  it { should_not allow_value('azsdf').for(:phone_number) }

end
