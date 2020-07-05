class Booking < ApplicationRecord
  belongs_to :booker, required: true
  belongs_to :product, required: true
  belongs_to :variant, required: true

  after_initialize :set_defaults, unless: :persisted?

  validates :starting_date, presence: true
  validates :ending_date, presence: true
  validates :actual_state, presence: true

  include PgSearch::Model
  pg_search_scope :search_in_bookings,
                  associated_against: {
                    product: [:reference, :model, :category, :sub_category],
                    booker: [:first_name, :last_name, :email, :phone_number]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }

  def confirm
    self.update(
      former_state: self.actual_state,
      actual_state: 'confirmed'
    )
    self.variant.update(stock: self.variant.stock - 1)
  end

  def cancel
    self.update(
      former_state: self.actual_state,
      actual_state: 'canceled'
    )
  end

  def pick_up
    self.update(
      former_state: self.actual_state,
      actual_state: 'picked'
    )
  end

  def back_in_stock
    self.update(
      former_state: self.actual_state,
      actual_state: 'back'
    )
    self.variant.update(stock: self.variant.stock + 1) if self.former_state == 'confirmed'
  end

  def is_closed?
    return false if ending_date > Date.today

    self.update(
      former_state: self.actual_state,
      actual_state: 'closed'
    )
  end

  # def undo_state_change
  #   self.actual_state = former_state
  # end

  private

  def set_defaults
    self.actual_state = 'pending'
    self.starting_date = Date.today if self.starting_date.nil?
    self.ending_date = starting_date + 3
  end
end
