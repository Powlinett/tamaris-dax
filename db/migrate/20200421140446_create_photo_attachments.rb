class CreatePhotoAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_attachments do |t|
      t.references :photo, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
