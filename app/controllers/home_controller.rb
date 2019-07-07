class HomeController < ApplicationController
  layout "homelayout", only: [:index2, :privacy, :user_term]
  
  def index
    product_service = ProductService.new
    @latest_products = product_service.latest
    @hot_products = product_service.hot
    @featured_products = product_service.featured
    @next_week_products = product_service.next_week_products
  end
  def index2
    
  end
  def privacy

  end
  def user_term

  end
end