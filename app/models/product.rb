class Product < ApplicationRecord
  belongs_to :category
  belongs_to :chef
  has_many :order_items
end
