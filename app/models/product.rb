class Product < ApplicationRecord
  has_many :bookings, dependent: :nullify
  has_many :variants, dependent: :destroy

  belongs_to :product_feature

  serialize :sizes_range, Array
  serialize :photos_urls, Array

  validates :reference, presence: true, uniqueness: true
  validates :category, presence: true
  validates :sub_category, presence: true
  validates :model, presence: true
  validates :price, presence: true, inclusion: { in: (0..300) }
  validates :color, presence: true
  validates :sizes_range, presence: true
  # validates :photos_urls, presence: true

  after_save :set_variants

  include PgSearch::Model
  pg_search_scope :search_in_products,
                  against: [:reference, :model, :category, :sub_category],
                  using: {
                    tsearch: { prefix: true }
                  }

  def set_variants
    sizes_range.each do |size|
      Variant.create(size: size, product: self)
    end
  end

  def french_price
    price = self.price.to_s
    price.split('.').join(',')
  end

  def french_former_price
    former_price = self.former_price.to_s
    former_price.split('.').join(',')
  end

  def common_ref
    ref_array = reference.split('-')
    ref_array = ref_array.reject { |x| ref_array.index(x) == ref_array.index(ref_array.last) }
    ref_array.join('-')
  end

  def still_any_stock?
    total_stock = 0
    variants.each { |variant| total_stock += variant.stock }
    total_stock.positive?
  end
end
