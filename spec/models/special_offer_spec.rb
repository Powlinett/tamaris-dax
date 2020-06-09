require 'rails_helper'

describe SpecialOffer do
  it { should belong_to :home_page }

  it { should validate_presence_of :home_page }
  it { should validate_presence_of :title }
end
