class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  enum status: {"pending" => 0, "paid" => "1"}

  validates :first_name, presence: true
  validates :last_name, presence: true
  

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

  def pickup_date_address
    output = {}
    available_days = self.order_items.group_by(&:available_day)
    available_days.keys.sort.each do |day|
      output[day]= {}
      items = available_days[day]
      chefs = items.map(&:product).map(&:chef).uniq
      chefs.each do |chef|
        output[day][chef.id] = {
          address: chef.address,
          products: items.select {|i| i.product.chef == chef}.map(&:product).map(&:name).join(",")
        }
      end
    end
    output
  end
  
end
