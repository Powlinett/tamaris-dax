class Product < ApplicationRecord
  has_many :bookings, dependent: :nullify
  has_many :variants, dependent: :destroy

  serialize :photos_urls, Array

  validates :reference, presence: true, uniqueness: true
  validates :category, presence: true
  validates :model, presence: true
  validates :price, presence: true, inclusion: { in: (0..400) }

  def french_price
    price = self.price.to_s
    price.split('.').join(',')
  end

  def french_former_price
    former_price = self.former_price.to_s
    former_price.split('.').join(',')
  end
end
