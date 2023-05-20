class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.string :name
      t.string :address
      t.text :description
      t.references :user, foreign_key: true
      t.text :image_name

      t.timestamps
    end
  end
end
