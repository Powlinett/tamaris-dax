class CreateVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :variants do |t|
      t.integer :size
      t.integer :stock, default: 0
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
