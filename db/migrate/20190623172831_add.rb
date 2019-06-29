class Add < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :reviews_count, :integer
  end
end
