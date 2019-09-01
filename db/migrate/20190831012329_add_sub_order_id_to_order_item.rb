class AddSubOrderIdToOrderItem < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :sub_order_id, :integer
  end
end
