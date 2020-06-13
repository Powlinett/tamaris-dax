require 'rails_helper'

describe Variant do
  it { should belong_to :product }
  it { should have_many :bookings }

  it { should validate_presence_of :stock }
  it { should validate_presence_of(:size) }
  it { should validate_uniqueness_of(:size).scoped_to(:product_id) }

  # before(:all) do
  #   @product = create(:product, reference: '1-1-22107-24-608')
  #   @variant = @product.variants.first
  # end

  # it 'should validate that stock is between 0 and 100' do
  #   expect(@variant.stock).to be_between(0, 100)

  #   @variant.stock = 102

  #   expect(@variant).to_not be_valid

  #   @variant.stock = -2

  #   expect(@variant).to_not be_valid

  #   @variant.stock = 22

  #   expect(@variant).to be_valid
  # end

  # it 'should validate that size are in sizes_range for shoes' do
  #   @variant.product.category = 'chaussures'
  #   @variant.size = 37

  #   expect(@variant).to be_valid

  #   @variant.size = 48

  #   expect(@variant).to_not be_valid
  # end

  # it 'should validate that size are in permitted_sizes for belts' do
  #   @variant.product.sub_category = 'ceintures'
  #   @variant.size = 115

  #   expect(@variant).to be_valid

  #   @variant.size = 39

  #   expect(@variant).to_not be_valid

  #   @variant.size = 112

  #   expect(@variant).to_not be_valid
  # end
end
