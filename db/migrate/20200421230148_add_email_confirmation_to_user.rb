class AddEmailConfirmationToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_confirmation, :string
  end
end
