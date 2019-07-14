class HomeController < ApplicationController
  layout "homelayout", only: [:index2, :privacy, :user_term]
  
  def index
    product_service = ProductService.new
    @latest_products = product_service.latest
    @hot_products = product_service.hot
    @featured_products = product_service.featured
    @next_week_products = product_service.next_week_products
    @today_products = product_service.daily_menu(Date.today+1.days)
  end 

  def daily
    product_service = ProductService.new
    @selected = product_service.daily_menu(Date.parse(params[:product_date]))
    respond_to do |format|
      format.js
    end
  end

  def daily
    product_service = ProductService.new
    @selected = product_service.daily_menu(Date.parse(params[:product_date]))
    respond_to do |format|
      format.js
    end
  end
  
  def index2
    
  end
  def privacy

  end
  def user_term

  end
end
