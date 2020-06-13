class Variant < ApplicationRecord
  belongs_to :product, required: true
  has_many :bookings, dependent: :nullify

  validates :stock, presence: true, inclusion: { in: 0..100 }
  validates :size, presence: true, uniqueness: { scope: :product_id }
  validate :permitted_sizes

  def permitted_sizes
    if (product.category == 'chaussures') || (product.sub_category == 'ceintures')
      unless product.sizes_range.include?(size)
        errors.add(:base, "The size isn't valid for this product")
      end
    end
  end
end
