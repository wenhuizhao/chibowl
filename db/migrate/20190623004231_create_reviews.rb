class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :product_id
      t.decimal :rating
      t.text :content
      t.integer :status

      t.timestamps
    end
  end
end
