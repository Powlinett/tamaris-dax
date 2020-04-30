class Variant < ApplicationRecord
  belongs_to :product
  has_many :bookings, dependent: :nullify

  validates :product, presence: true
  validates :size, presence: true, inclusion: { in: 35..42 }, uniqueness: { scope: :product }
  validates :stock, presence: true, inclusion: { in: 0..100 }

  def update_size_stock(new_stock)
    self.stock += new_stock
  end
end
