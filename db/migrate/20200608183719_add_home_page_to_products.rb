class AddHomePageToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :home_page, index: true
    add_foreign_key :products, :home_pages
  end
end
