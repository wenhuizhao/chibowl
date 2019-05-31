class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :status
      t.integer :quantity
      t.float :price
      t.text :detail

      t.timestamps
    end
  end
end
