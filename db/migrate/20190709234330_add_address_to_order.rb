class AddAddressToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :address, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :country, :string
    add_column :orders, :zipcode, :string
    add_column :orders, :email, :string
    add_column :orders, :phone, :string
    add_column :orders, :shipping_address_check, :boolean
    add_column :orders, :shipping_first_name, :string
    add_column :orders, :shipping_last_name, :string
    add_column :orders, :shipping_address, :string
    add_column :orders, :shipping_city, :string
    add_column :orders, :shipping_state, :string
    add_column :orders, :shipping_country, :string
    add_column :orders, :shipping_zipcode, :string
    add_column :orders, :shipping_email, :string
    add_column :orders, :shipping_phone, :string

  end
end
