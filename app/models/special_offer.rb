class SpecialOffer < ApplicationRecord
  belongs_to :home_page

  validates :home_page, presence: true
  validates :title, presence: true, allow_blank: false
end
