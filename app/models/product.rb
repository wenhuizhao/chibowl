class Product < ApplicationRecord
  belongs_to :category
  belongs_to :department
  belongs_to :chef
  has_many :order_items
  has_many :photos, as: :owner
  has_many :reviews
  has_many :product_relations
  has_many :related_products, through: :product_relations, class_name: "Product",
    foreign_key: 'related_product_id', source: :related_product
  enum status: { created: 0, active: 1, inactive: 2}

  def files=(array_of_files = [])
    array_of_files.each do |f|
      photos.build(image: f, owner: self)
    end
  end

  def price_with_unit
    "$#{price}"
  end

  def sell_price_with_unit
    "$#{sell_price}"
  end

  def photo1_url
    photos[0]&.image&.url
  end

  def photo2_url
    (photos[1]||photos[0])&.image.url
  end

  def photo3_url
    (photos[2]||photos[0])&.image.url
  end

  def photo1_url_medium
    photos[0]&.image&.url(:medium)
  end

  def photo2_url_medium
    (photos[1] || photos[0])&.image.url(:medium)
  end

  def photo3_url_medium
    (photos[2]|| photos[0])&.image.url(:medium)
  end


end
