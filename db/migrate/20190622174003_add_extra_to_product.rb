class AddExtraToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :extra, :text
  end
end
