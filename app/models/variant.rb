class Variant < ApplicationRecord
  SHOES_PERMITTED_SIZES = (35..43).to_a
  BELT_PERMITTED_SIZES = (70..130).select { |i| (i % 5).zero? }

  belongs_to :product
  has_many :bookings, dependent: :nullify

  validates :product, presence: true
  validates :stock, presence: true, inclusion: { in: 0..100 }
  validates :size, presence: true, uniqueness: { scope: :product_id }
                   # inclusion: { in: PERMITTED_SIZES }
                   # case_sensitive: false
  validates :size, inclusion: { in: SHOES_PERMITTED_SIZES },
                   if: Proc.new { |v| v.product.category == 'chaussures' }
  validates :size, inclusion: { in: BELT_PERMITTED_SIZES },
                   if: Proc.new { |v| v.product.sub_category == 'ceintures' }
end
