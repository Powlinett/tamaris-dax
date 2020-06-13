class SpecialOffer < ApplicationRecord
  belongs_to :home_page, required: true

  validates :home_page, presence: true
  validates :title, presence: true, allow_blank: false
end
