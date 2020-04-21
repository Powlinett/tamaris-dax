class ChangeNameToModelInProduct < ActiveRecord::Migration[5.2]
  def change
    rename_column :products, :name, :model
  end
end
