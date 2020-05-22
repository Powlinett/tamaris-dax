class AddProductFeaturesToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :product_feature, index: true
    add_foreign_key :products, :product_features
  end
end
