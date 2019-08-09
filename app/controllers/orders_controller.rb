class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only:[:index, :update, :destroy, :edit]
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
    if !current_user&.admin?
      redirect_to home_error_page_path
    end
  end
  # GET orders/order_by_available_day
  def order_by_available_day
    # @orders = Order.where("order_date > ? and order_date < ?",(Date.today),(Date.today+8.days))
    # @result={}
    # @orders.each do |order|
    #   order.order_items.each do |order_item|
    #     available_day=order_item.available_day
    #     if !@result.key?(available_day)
    #       @result[available_day]=[order_item]
    #     else
    #       @result[available_day].push(order_item)
    #     end
    #   end
    # end
    @orders = Order.all
    @by_chef={}
    @by_customer={}
    @orders.each do |order|
      order.order_items.select{|item| item.available_day==params[:anything][:available_day]}.each do |order_item|
        customer = order_item.order.first_name+"&"+order_item.order.last_name+"&"+order_item.order.email+"&"+order_item.order.phone
        chef = order_item.product.chef.name
        if !@by_chef.key?(chef)
          @by_chef[chef]=[order_item]
        else
          @by_chef[chef].push(order_item)
        end
        if !@by_customer.key?(customer)
          @by_customer[customer]=[order_item]
        else
          @by_customer[customer].push(order_item)
        end
      end
    end
  end
 

  # GET /orders/1
  # GET /orders/1.json
  def show
    @clear_cart = params[:clear_cart]
  end

  # GET /orders/1/view
  # GET /orders/1/view.json
  def view
    @order = Order.find_by_uuid(params[:uuid])
    redirect_to details_order_path(@order)
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
        UserMailer.with(order:@order).order_email.deliver_later
        if @order.pay_by_wechat? || @order.pay_by_alipay? || @order.pay_by_stripe?
          @response = YuansferService.new(@order).call
          format.html { redirect_to @response["result"]["cashierUrl"], layout: false}
        else
          format.html { redirect_to order_path(@order, clear_cart:true), notice: t('.order_success') }
          format.json { render :show, status: :created, location: @order }
        end
      else
        format.html { render :checkout, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
    
  end

  def stripe_charge
    order_id = params[:order_id]
    @order = Order.find_by_id(order_id)
    StripeChargesService.new(params[:stripeEmail], params[:stripeToken], order_id, current_user).call
    render :payment_success
  end

  def details
    @order = Order.find(params[:id])
  end

  def choose_date
    if !current_user&.admin?
      redirect_to home_error_page_path
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

    def check_permission
      if @order&.user_id!=current_user&.id&& !current_user.admin?
        redirect_to home_error_page_path
      end
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:user_id, :status, :order_date, :detail,
        :first_name, :last_name, :address, :city, :state, :country, :zipcode,
        :shipping_address_check,
        :shipping_first_name, :shipping_last_name, :shipping_address, :shipping_city,
        :shipping_state, :shipping_country, :shipping_zipcode, :paying_method, :email, :phone,
        :stripeEmail, :stripeToken
        )
    end
end
