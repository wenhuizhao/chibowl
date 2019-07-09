class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  enum status: {"pending" => 0, "paid" => "1"}

  def subtotal
    self.order_items.map(&:subtotal).sum
  end

  def shipping
    0
  end

  def total
    self.subtotal + self.shipping
  end
end
