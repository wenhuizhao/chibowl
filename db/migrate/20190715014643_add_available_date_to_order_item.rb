class AddAvailableDateToOrderItem < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :available_day, :date
  end
end
