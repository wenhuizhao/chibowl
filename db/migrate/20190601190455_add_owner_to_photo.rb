class AddOwnerToPhoto < ActiveRecord::Migration[5.0]
  def change
    remove_column :photos, :product_id, :integer
    add_column :photos, :owner_id, :integer
    add_column :photos, :owner_type, :string
  end
end
