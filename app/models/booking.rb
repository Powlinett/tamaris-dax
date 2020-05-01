class Booking < ApplicationRecord
  belongs_to :booker
  belongs_to :product
  belongs_to :variant

  validates :booker, presence: true
  validates :product, presence: true
  validates :variant, presence: true

  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.actual_state = 'pending'
    self.former_state = actual_state
    self.starting_date = Date.today.strftime("%A %d/%m/%Y")
    self.ending_date = (Date.today + 3).strftime("%A %d/%m/%Y")
  end

  def confirm_booking
    self.former_state = actual_state
    self.actual_state = 'confirmed'
  end

  def cancel_booking
    self.former_state = actual_state
    self.actual_state = 'canceled'
  end

  def pick_up
    self.former_state = actual_state
    self.actual_state = 'picked'
  end

  def back_in_stock
    self.former_state = actual_state
    self.actual_state = 'back'
  end

  def booking_closed?
    self.former_state = actual_state
    return unless ending_date < Date.today

    self.actual_state = 'closed'
    save
  end

  def undo_state_change
    self.actual_state = former_state
  end
end
