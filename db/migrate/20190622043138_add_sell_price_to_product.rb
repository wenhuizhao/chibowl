class AddSellPriceToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :sell_price, :decimal
    add_column :products, :rating, :decimal
    add_column :products, :department_id, :integer
  end
end
