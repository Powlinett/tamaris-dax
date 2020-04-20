class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :reference
      t.string :name
      t.string :type
      t.integer :size
      t.integer :stock

      t.timestamps
    end
  end
end
