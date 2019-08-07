class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  enum status: {"pending" => "0", "paid" => "1", "deliveried" =>"2"}

  before_validation :set_uuid, on: :create
  validates :first_name, presence: true
  validates :last_name, presence: true
  validate :subtotal_not_zero

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def pay_by_stripe?
    self.paying_method == 'byStripe'
  end

  def pay_by_wechat?
    self.paying_method == 'byWeChat'
  end

  def pay_by_alipay?
    self.paying_method == 'byAlipay'
  end

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
    2
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

  def pickup_date_restaunt
    output = {}
    available_days = self.order_items.group_by(&:available_day)
    available_days.keys.sort.each do |day|
      output[day]= {}
      items = available_days[day]
      chefs = items.map(&:product).map(&:chef).uniq
      chefs.each do |chef|
        product_array = []
          items.select {|i| i.product.chef == chef}.each do |item|
            product_array.push(item.product.name+": "+item.quantity.to_s)
          end
        output[day][chef.id] = {
          name: chef.name,
          products: product_array
        }
      end
    end
    output
  end
  
end
