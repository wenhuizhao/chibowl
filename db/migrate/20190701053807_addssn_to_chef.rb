class AddssnToChef < ActiveRecord::Migration[5.2]
  def change
    add_column :chefs, :ssn, :string
  end
end
