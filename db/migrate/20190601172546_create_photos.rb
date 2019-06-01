class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :title
      t.integer :product_id
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
