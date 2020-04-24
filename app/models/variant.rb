class Variant < ApplicationRecord
  belongs_to :product
  has_many :bookings

  validates :product, presence: true
  validates :size, presence: true, inclusion: { in: 35..43 }, uniqueness: { scope: :product }
  validates :stock, presence: true, inclusion: { in: 0..100 }

  def update_size_stock(variant_id, new_stock)
    variant = Variant.find(variant_id)
    variant.stock += new_stock
    variant.save
  end
end
