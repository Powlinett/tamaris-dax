require 'rails_helper'

# SHOES_PERMITTED_SIZES = (35..43).to_a
# BELT_PERMITTED_SIZES = (70..130).select { |i| (i % 5).zero? }

describe Variant do
  it { should belong_to :product }
  it { should have_many :bookings }

  it { should validate_presence_of :stock }
  it { should validate_presence_of(:size) }
  it { should validate_uniqueness_of(:size).scoped_to(:product_id).case_insensitive }

  before(:all) do
    @variant = build(:variant)
    @variant.product.variants.destroy_all
  end

  it 'should validate that stock is between 0 and 100' do
    expect(@variant.stock).to be_between(0, 100)

    @variant.stock = 102

    expect(@variant).to_not be_valid

    @variant.stock = -2

    expect(@variant).to_not be_valid

    @variant.stock = 22

    expect(@variant).to be_valid
  end

  it 'should validate that size are in permitted_sizes for shoes' do
    @variant.product.category = 'chaussures'
    @variant.size = 37

    expect(@variant).to be_valid

    @variant.size = 48

    expect(@variant).to_not be_valid
  end

  it 'should validate that size are in permitted_sizes for accessories' do
    @variant.product.category = 'accessoires'
    @variant.size = 115

    expect(@variant).to be_valid

    @variant.size = 39

    expect(@variant).to_not be_valid

    @variant.size = 112

    expect(@variant).to_not be_valid
  end

  # describe '#update_stock' do
  #   it 'updates stock' do
  #     expect { @variant.update_stock(2) }.to change { @variant.stock }.by(2)
  #   end
  # end
end
