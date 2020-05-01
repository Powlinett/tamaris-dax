class Booking < ApplicationRecord
  belongs_to :booker
  belongs_to :product
  belongs_to :variant

  validates :booker, presence: true
  validates :product, presence: true
  validates :variant, presence: true

  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.state = 'pending'
    self.starting_date = Date.today.strftime("%A %d/%m/%Y")
    self.ending_date = (Date.today + 3).strftime("%A %d/%m/%Y")
  end

  def confirm_booking
    self.state = 'confirmed'
  end

  def cancel_booking
    self.state = 'canceled'
  end

  def pick_up
    self.state = 'picked'
  end

  def booking_closed?
    return unless ending_date < Date.today

    self.state = 'closed'
    save
  end
end
