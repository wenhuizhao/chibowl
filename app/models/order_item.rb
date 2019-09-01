class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :sub_order, optional: true
  enum status: {"pending" => 0, "paid" => "1","deliveried" => "2"}

  def subtotal
    self.quantity * self.product.real_price
  end
end
