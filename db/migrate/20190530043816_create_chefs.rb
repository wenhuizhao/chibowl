class CreateChefs < ActiveRecord::Migration[5.0]
  def change
    create_table :chefs do |t|
      t.string :name
      t.string :desc
      t.text :street
      t.string :city
      t.string :state
      t.string :country
      t.string :zip
      t.integer :user_id
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
