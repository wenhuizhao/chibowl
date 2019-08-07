class CreateTransaction < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :order_id
      t.string :yuansfer_id
      t.integer :status
      t.float :amount
      t.float :refund_amount
      t.float :void_amount
      t.integer :transaction_type
      t.string :currency
      t.datetime :payment_time
      t.float :exchange_rate
      t.string :vendor
    end
  end
end
