class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :review]
  before_action :authenticate_user!, only: [:edit, :update, :create, :destroy]
  before_action :check_permission, only:[:index, :update, :destroy, :edit]
  # GET /orders
  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    if !current_user&.admin?
      redirect_to home_error_page_path
    end
  end

  #GET /products/multiple_edit
  def multiple_edit
    @products = Product.all
    if !current_user&.admin?
      redirect_to home_error_page_path
    end
  end

  #GET /products/available_day_multiple_edit
  def available_day_multiple_edit
    @products = Product.find(params[:product_ids])
    if !current_user&.admin?
      redirect_to home_error_page_path
    end
  end

  #POST /products/available_day_multiple_update
  def available_day_multiple_update
    @products = Product.find(params[:product_ids])
    if @products.empty?
      redirect_to products_path
    else
      condition = true
      @products.each do |product|
        condition = condition && product.update_attributes(:available_day => params[:empty_attr][:available_day])
      end
      respond_to do |format|
        if condition
          format.html {redirect_to multiple_edit_products_path, notice: "Products' available day were updated."}
          format.json {render :multiple_edit, status: :ok}
        else
          format.html { render :multiple_edit, status: :unprocessable_entitys, notice: "Please try again." }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def review 
    review_content = params[:review_content]
    rating = params[:rating]
    @review = @product.reviews.build({
      user_id: current_user.id,
      content: review_content,
      rating: rating
    })
    respond_to do |format|
      if @product.save
        format.json {render json: {reviews: @product.reviews}}
        format.js
      else
        format.json { render json: @product.errors, status: :unprocessable_entity}
      end
    end
  end

  def check_permission
    if @order&.user_id!=current_user&.id&& !current_user.admin?
      redirect_to home_error_page_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :category_id,:department_id, :chef_id, 
        :price, :sell_price, :desc,:extra, :rating, :featured, :hot, :status,
        :available_day, files: [])
    end
end
