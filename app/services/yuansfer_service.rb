require 'digest/md5'
require 'net/http'

class YuansferService
  def initialize(order, vendor)
    @api_token = Rails.configuration.yuansfer[:api_token]
    @url = Rails.configuration.yuansfer[:url]
    @mechant_no = Rails.configuration.yuansfer[:mechat_no]
    @store_no = Rails.configuration.yuansfer[:store_no]
    @ipn_url = 'https://www.chibowl.com/yuansfer/ipn'
    @callbck_url = 'https://www.chibowl.com/yuansfer/callback'
    @amount = order.total
    @currency = 'USD'
    @timeout = 120
    @goods_info = @order.order_items.map do |item|
      {
        'name': item.product.name,
        'quantity': item.quantity
      }
    @vendor = vendor
    end
  end

  def call
    make_post_req
  end

  private

  def signature
    api_token_md5 = Digest::MD5.hexdigest(@api_token)
    buf = %q(
    amount=#{@amount}&callbackUrl=#{@callback_url}&currency=#{currencty}&
    goodsInfo=#{@goods_info}&ipnUrl=#{@ipnUrl}&mechantNo=#{@machant_no}&
    reference=#{@order.id}&storeNo=#{@store_no}&terminal=ONLINE&timeout=#{@timeout}&
    vendor=#{@vendor}&#{api_token}
    )
    Digest::Md5.hexdigest(buf)
  end

  def request_params
    {
      mechantNo: @mechant_no,
      storeNo: @store_no,
      amount: @amount,
      currency: @curreny,
      vendor: @vendor,
      ipnUrl: @ipn_url,
      callbackUrl: @callback_url,
      timeout: @timeout,
      goodsInfo: @goods_info,
      verifySign: @signature
    }
  end
  def make_post_req
    begin
        uri = URI(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'}) 
        req.body = request_params.to_json
        res = http.request(req)
        puts "response #{res.body}"
        res.body
    rescue => e
        puts "failed #{e}"
    end
  end  
end