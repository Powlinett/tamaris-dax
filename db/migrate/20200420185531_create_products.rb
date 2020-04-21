class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :reference
      t.string :model
      t.string :category
      t.float  :price
      t.integer :size
      t.integer :stock

      t.timestamps
    end
  end
end
