class AddPayingMethodToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :paying_method, :string
  end
end
