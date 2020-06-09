require 'rails_helper'

describe HomePage do
  it { should have_one :special_offer }
  it { should have_one :product }

  it { should validate_presence_of :product }
end
