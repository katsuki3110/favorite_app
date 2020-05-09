class CreateSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :spots do |t|
      t.integer :post_id
      t.string :place
      t.string :image_spot
      t.string :explaine

      t.timestamps
    end
  end
end
