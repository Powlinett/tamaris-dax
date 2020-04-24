class Variant < ApplicationRecord
  belongs_to :product

  validates :product, presence: true
  validates :size, presence: true, inclusion: { in: 35..43 }
  validates :stock, presence: true, inclusion: { in: 0..100 }

  def update_size_stock(variant_id, new_stock)
    variant = Variant.find(variant_id)
    variant.stock += new_stock
    variant.save
  end
end
