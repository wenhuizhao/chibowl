class SubOrder < ApplicationRecord
  belongs_to :order 
  belongs_to :chef
  has_many :order_items
  enum status: {"pending" => 0, "deliveried" => 1, "canceled" => 2}
  
  

  def subtotal_not_zero
    if self.subtotal <= 0
      self.errors.add(:order_items, :subtotal_zero)
    end
  end

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
