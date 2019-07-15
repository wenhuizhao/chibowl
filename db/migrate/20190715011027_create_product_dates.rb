class CreateProductDates < ActiveRecord::Migration[5.2]
  def change
    create_table :product_dates do |t|
      t.integer :product_id
      t.date :date

      t.timestamps
    end
  end
end
