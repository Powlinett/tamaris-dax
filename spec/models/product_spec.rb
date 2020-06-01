require 'rails_helper'

describe Product do
  it { should belong_to :product_feature }
  it { should have_many :variants }
  it { should have_many :bookings }

  it { should validate_presence_of :reference }
  it { should validate_uniqueness_of(:reference).case_insensitive }
  it { should validate_presence_of :category }
  it { should validate_presence_of :sub_category }
  it { should validate_presence_of :model }
  it { should validate_presence_of :price }
  it { should validate_presence_of :color }
  it { should validate_presence_of :sizes_range }

  it { should serialize :sizes_range }
  it { should serialize :photos_urls }

  before(:all) do
    @product = build(:product)
    @product2 = create(:product, reference: "1-1-22107-24-003")
  end

  it 'should validate inclusion of price between 0 and 300 euros' do
    expect(@product.price).to be_between(0, 300)
  end

  describe '#set_variants' do
    it "creates all the Variant instances" do
      expect(@product2.variants).to_not be_empty
      expect(@product2.variants.count).to eq(@product.sizes_range.count)
    end
  end

  describe '#french_format' do
    it 'tranforms the price to french format' do
      @product.french_format(@product.price)

      expect(@product.french_format(@product.price)).to eq('59,95')
    end
  end

  describe '#common_ref' do
    it 'returns the reference without color ref' do
      expect(@product.common_ref).to eq("1-1-22107-24")
    end
  end

  describe '#still_any_stock?' do
    it "returns false if product don't have any stock" do
      expect(@product2.still_any_stock?).to eq(false)
    end

    it 'return true if product has stock' do
      @product2.variants.first.stock = 1

      expect(@product2.still_any_stock?).to eq(true)
    end
  end
end
