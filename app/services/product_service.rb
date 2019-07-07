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

  def next_week_products
    Product.where("available_day  >? and available_day <?",  (Time.now+1.days).beginning_of_day,  (Time.now+7.days).end_of_day)
  end
end
