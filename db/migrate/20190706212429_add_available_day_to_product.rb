class AddAvailableDayToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :available_day, :date
  end
end
