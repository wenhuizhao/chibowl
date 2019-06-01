class AddFeaturedToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :featured, :boolean
  end
end
