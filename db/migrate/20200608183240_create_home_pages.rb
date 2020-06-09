class CreateHomePages < ActiveRecord::Migration[5.2]
  def change
    create_table :home_pages do |t|
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
