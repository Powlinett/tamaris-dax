class ChangeStatutToUser < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :statut, :status
  end
end
