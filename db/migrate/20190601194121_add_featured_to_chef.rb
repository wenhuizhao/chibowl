class AddFeaturedToChef < ActiveRecord::Migration[5.0]
  def change
    add_column :chefs, :featured, :boolean
  end
end
