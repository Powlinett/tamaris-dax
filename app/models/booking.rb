class Booking < ApplicationRecord
  belongs_to :booker
  belongs_to :product
  belongs_to :variant

  validates :booker, presence: true
  validates :product, presence: true
  validates :variant, presence: true

  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.state = 'En attente de confirmation'
    self.starting_date = Date.today.strftime("%A %d/%m/%Y")
    self.ending_date = (Date.today + 3).strftime("%A %d/%m/%Y")
  end

  def confirm_booking
    self.state = 'Réservation confirmée'
  end

  def cancel_booking
    self.state = 'Réservation impossible'
  end

  def pick_up
    self.state = 'Réservation récupérée'
  end
end
