class ChangeSellPriceToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :sell_price, :float
  end
end
