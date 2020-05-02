class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string  :reference
      t.string  :model
      t.string  :color
      t.string  :category
      t.string  :sub_category
      t.float   :price
      t.float   :former_price
      t.text    :sizes_range
      t.text    :photos_urls

      t.timestamps
    end
  end
end
