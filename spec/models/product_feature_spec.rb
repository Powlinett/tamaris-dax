require 'rails_helper'

describe ProductFeature do
  it { should have_many :products }

  it { should validate_presence_of :features_hash }
  it { should serialize :features_hash }
end
