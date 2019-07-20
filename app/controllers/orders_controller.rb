class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @clear_cart = params[:clear_cart]
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /orders/cart
  def cart
    @order = prepare_order()

  end

  # GET /orders/checkout
  def checkout
    @order = prepare_order()
  end

  def place_order
    @order = prepare_order(order_params)
    respond_to do |format|
      if @order.save
        format.html { redirect_to order_path(@order, clear_cart:true), notice: t('.order_success') }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :checkout, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
    
  end
  private
    def prepare_order(place_order_params=nil)
      order = Order.new(place_order_params)
      order.user_id = current_user&.id || GuestUser.new.id
      order.status = Order.statuses[:pending]
      order.order_date = Time.now
      order.paying_method = params[:paying_method]
      product_ids = (params[:product_ids] || "").split(",").map(&:to_i)
      quantities= (params[:quantities] || "").split(",").map(&:to_i)
      product_ids.each_with_index do |product_id, index|
        product = Product.find(product_id)
        order.order_items.build({
          product_id: product_id,
          quantity: quantities[index],
          price: product&.real_price,
          available_day: product&.available_day
        })
      end
      order
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:user_id, :status, :order_date, :detail,
        :first_name, :last_name, :address, :city, :state, :country, :zipcode,
        :shipping_address_check,
        :shipping_first_name, :shipping_last_name, :shipping_address, :shipping_city,
        :shipping_state, :shipping_country, :shipping_zipcode, :paying_method, :email, :phone
        )
    end
end
