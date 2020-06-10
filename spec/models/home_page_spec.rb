require 'rails_helper'

describe HomePage do
  it { should have_one :special_offer }
  it { should belong_to :product }

  it { should validate_presence_of :product }
end
