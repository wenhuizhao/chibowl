class ProductService

  def latest
    Product.where(status: :active).order(:created_at, :desc).limit(20)
  end

  def hot
    Product.where(hot: true, status: :active).order(:created_at, :desc).limit(20)
  end

  def featured
    Product.where(featured: true, status: :active).order(:created_at, :desc).limit(20)
  end

end
