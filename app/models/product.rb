class Product < ApplicationRecord
  has_many :bookings, dependent: :nullify
  has_many :variants, dependent: :destroy

  serialize :sizes_range
  serialize :photos_urls, Array

  validates :reference, presence: true, uniqueness: true
  validates :category, presence: true
  validates :model, presence: true
  validates :price, presence: true, inclusion: { in: (0..300) }

  after_initialize :set_variants

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
    reference.split('-')[0..3].join('-')
  end
end
