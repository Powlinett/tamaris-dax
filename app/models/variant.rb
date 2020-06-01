class Variant < ApplicationRecord
  PERMITTED_SIZES = [1, (35..43).to_a, (70..130).select { |i| (i % 5).zero? }].flatten.freeze

  belongs_to :product
  has_many :bookings, dependent: :nullify

  validates :product, presence: true
  validates :stock, presence: true, inclusion: { in: 0..100 }
  validates :size, presence: true, uniqueness: { scope: :product_id },
                   inclusion: { in: PERMITTED_SIZES },
                   case_sensitive: false

  def update_stock(new_stock)
    self.stock += new_stock
  end
end
