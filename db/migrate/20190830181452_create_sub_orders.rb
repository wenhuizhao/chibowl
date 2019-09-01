class CreateSubOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_orders do |t|
      t.integer :order_id
      t.integer :chef_id
      t.datetime :pick_up_date
      t.datetime :updated_at
      t.integer :status

      t.timestamps
    end
  end
end
