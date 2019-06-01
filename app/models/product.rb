class Product < ApplicationRecord
  belongs_to :category
  belongs_to :chef
  has_many :order_items
  has_many :photos, as: :owner
  scope :featured, -> { where(featured: true)}
end
