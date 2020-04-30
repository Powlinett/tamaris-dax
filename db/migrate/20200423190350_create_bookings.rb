class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.date :starting_date
      t.date :ending_date
      t.string :state
      t.references :booker, foreign_key: true
      t.references :product, foreign_key: true
      t.references :variant, foreign_key: true

      t.timestamps
    end
  end
end
