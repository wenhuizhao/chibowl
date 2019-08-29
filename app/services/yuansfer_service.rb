require 'digest/md5'
require 'net/http'
require 'net/https'

class YuansferService
  def initialize(order)
    @api_token = Rails.configuration.yuansfer[:api_token]
    @url = Rails.configuration.yuansfer[:url] + '/online/v2/secure-pay'
    @merchant_no = Rails.configuration.yuansfer[:mechant_no]
    @store_no = Rails.configuration.yuansfer[:store_no]
<<<<<<< HEAD
    @ipn_url = 'http://localhost:3000/yuansfer/ipn'
    @callback_url = 'http://localhost:3000/yuansfer/callback?yuansferId={yuansferId}&status={status}&amount={amount}&time={time}&reference={reference}&note={note}&verifySign={verifySign}'
=======
    @ipn_url = 'https://www.chibowl.com/yuansfer/ipn'
    @callback_url = 'https://www.chibowl.com/yuansfer/callback?yuansferId={yuansferId}&status={status}&amount={amount}&time={time}&reference={reference}&note={note}&verifySign={verifySign}'
>>>>>>> master
    @amount = order.total
    @currency = "USD"
    @timeout = 120
    @order_id = order.id.to_s
    #@order_id = 218
    @terminal = "ONLINE"
    @goods_info = order.order_items.map do |item|
      {
        "name": item.product.name,
        "quantity": item.quantity.to_s
      }
    end.to_json
    if order.paying_method == "byAlipay"
      @vendor = "alipay"
    elsif order.paying_method == "byWeChat"
      @vendor = "wechatpay"
    elsif order.paying_method == 'byStripe'
      @vendor = 'unionpay'
    end
  end

  def call
    response=make_post_req
    JSON.parse(response)
  end

  private

  def test_params
    
    #@amount= '0.01'
    # @callback_url= 'https://wx.yuansfer.yunkeguan.com/wx'
    # @currency= 'USD'
     @goods_info= '[{"goods_name":"Yuansfer","quantity":"1"}]'
    # @goods_info = '[]'
    # @ipn_url= 'https://wx.yuansfer.yunkeguan.com/wx'
    # @merchant_no= '200043'
    # @order_id= 'seq_1525922323'
    # @store_no= '300014'
    # @terminal= 'ONLINE'
    # @timeout= '120'
    # @vendor= 'alipay'
  end

  def signature
    api_token_md5 = Digest::MD5.hexdigest(@api_token)
    buf = "amount=#{@amount}&callbackUrl=#{@callback_url}&currency=#{@currency}&goodsInfo=#{@goods_info}&ipnUrl=#{@ipn_url}&merchantNo=#{@merchant_no}&reference=#{@order_id}&storeNo=#{@store_no}&terminal=#{@terminal}&timeout=#{@timeout}&vendor=#{@vendor}&#{api_token_md5}"
    Digest::MD5.hexdigest(buf)
  end

  def request_params
    {
      merchantNo: @merchant_no,
      storeNo: @store_no,
      amount: @amount,
      currency: @currency,
      vendor: @vendor,
      ipnUrl: @ipn_url,
      callbackUrl: @callback_url,
      terminal: @terminal,
      reference: @order_id.to_s,
      timeout: @timeout,
      goodsInfo: @goods_info,
      verifySign: signature
    }
  end


  
  def make_post_req
    begin
        uri = URI(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(uri.path) 
        test_params
        param = request_params
        #binding.pry
        req.set_form_data(param)
        res = http.request(req)
        puts "response #{res.body}"
        res.body
    rescue => e
        puts "failed #{e}"
    end
  end  
end