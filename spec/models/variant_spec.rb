require 'rails_helper'

PERMITTED_SIZES = [1, (35..43).to_a, (70..130).select { |i| (i % 5).zero? }].flatten.freeze

describe Variant do
  it { should belong_to :product }
  it { should have_many :bookings }

  it { should validate_presence_of :product }
  it { should validate_presence_of :stock }
  it { should validate_presence_of(:size) }
  it { should validate_uniqueness_of(:size).scoped_to(:product_id).case_insensitive }

  before(:all) do
    @variant = build(:variant)
  end

  it 'should validate that stock is between 0 and 100' do
    expect(@variant.stock).to be_between(0, 100)

    @variant.stock = 102

    expect(@variant).to_not be_valid
  end

  it 'should validate that size are in permitted_sizes constant' do
    expect(PERMITTED_SIZES).to include(@variant.size)

    @variant.size = 13

    expect(PERMITTED_SIZES).to_not include(@variant.size)
    expect(@variant).to_not be_valid
  end

  describe '#update_stock' do
    it 'updates stock' do
      expect { @variant.update_stock(2) }.to change { @variant.stock }.by(2)
    end
  end
end
