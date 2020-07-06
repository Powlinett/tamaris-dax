class Product < ApplicationRecord
  has_many :bookings, dependent: :nullify
  has_many :variants, dependent: :destroy

  has_one :home_page

  belongs_to :product_feature, required: true

  serialize :sizes_range, Array
  serialize :photos_urls, Array

  validates :reference, presence: true, uniqueness: true, case_sensitive: false
  validates :category, presence: true
  validates :sub_category, presence: true
  validates :model, presence: true
  validates :price, presence: true, inclusion: { in: (0..300) }
  validates :color, presence: true
  validates :sizes_range, presence: true

  after_create :set_variants

  include PgSearch::Model
  pg_search_scope :search_in_products,
                  against: [:reference, :model, :category, :sub_category, :color],
                  using: {
                    tsearch: { prefix: true }
                  }

  def french_format(price)
    price.to_s.split('.').join(',')
  end

  def common_ref
    ref_array = reference.split('-')
    ref_array = ref_array[0...-1]
    ref_array.join('-')
  end

  def color_ref
    ref_array = reference.split('-')
    ref_array[-1]
  end

  def update_variant(params)
    if (self.category == 'accessoires') && (params[:size].to_i == 1)
      variant = self.variants.first
    else
      variant = self.variants.find_by(size: params[:size].to_i)
    end
    if variant.present?
      variant.update(stock: variant.stock += params[:stock].to_i)
    else
      false
    end
  end

  def still_any_stock?
    total_stock = 0
    variants.each { |variant| total_stock += variant.stock }
    total_stock.positive?
  end

  private

  def set_variants
    sizes_range.each do |size|
      Variant.create(size: size, product: self)
    end
  end
end
