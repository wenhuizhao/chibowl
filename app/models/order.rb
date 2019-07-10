class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  enum status: {"pending" => 0, "paid" => "1"}

  def subtotal
    self.order_items.map(&:subtotal).sum
  end

  def subtotal_with_unit
    "$#{self.subtotal.round(2)}"
  end

  def shipping
    0
  end

  def total
    self.subtotal + self.shipping
  end

  def total_with_unit
    "$#{self.total.round(2)}"
  end
end
