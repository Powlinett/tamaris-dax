class CreateSpecialOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :special_offers do |t|
      t.string :title
      t.string :description
      t.date :starting_date
      t.date :ending_date

      t.references :home_page, foreign_key: true

      t.timestamps
    end
  end
end
