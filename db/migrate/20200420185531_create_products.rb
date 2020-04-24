class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string  :reference
      t.string  :model
      t.string  :category
      t.float   :price
      t.text    :photos_urls

      t.timestamps
    end
  end
end
