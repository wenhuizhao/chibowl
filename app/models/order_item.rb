class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  enum status: {"pending" => 0, "paid" => "1"}
end
