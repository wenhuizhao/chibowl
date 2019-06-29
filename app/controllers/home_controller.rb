class HomeController < ApplicationController
  def index
    product_service = ProductService.new
    @latest_products = product_service.latest
    @hot_products = product_service.hot
    @featured_products = product_service.featured
  end
end