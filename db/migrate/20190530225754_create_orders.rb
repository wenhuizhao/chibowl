class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :status
      t.datetime :order_date
      t.text :detail

      t.timestamps
    end
  end
end
