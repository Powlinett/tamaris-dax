require 'rails_helper'

describe HomePage do
  it { should have_many :special_offers }
  it { should have_many :products }
end
