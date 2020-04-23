class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :email_confirmation
      t.string :phone_number
      t.string :status
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
