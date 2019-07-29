class StripeChargesService
  DEFAULT_CURRENCY = 'usd'.freeze
  
  def initialize(stripe_email, stripe_token, order_id, user)
    @stripe_email = stripe_email
    @stripe_token = stripe_token
    @order_id = order_id
    @user = user
  end

  def call
    create_charge(find_customer)
  end

  private

  attr_accessor :user, :stripe_email, :stripe_token, :order_id

  def find_customer
  if user.stripe_id
    retrieve_customer(user.stripe_id)
  else
    create_customer
  end
  end

  def retrieve_customer(stripe_id)
    Stripe::Customer.retrieve(stripe_id) 
  end

  def create_customer
    customer = Stripe::Customer.create(
      email: stripe_email,
      source: stripe_token
    )
    user.update(stripe_id: customer.id)
    customer
  end

  def create_charge(customer)
    Stripe::Charge.create(
      customer: customer.id,
      amount: order_amount,
      description: customer.email,
      currency: DEFAULT_CURRENCY
    )
  end

  def order_amount
    (Order.find_by(id: order_id).total * 100).to_i
  end
end
