class YuansferController < ApplicationController
  skip_before_action :verify_authenticity_token

  def test

  end

  def callback
    Rails.logger.debug('params of callback:' + params.to_s)
    yuansfer_id = params[:yuansferId]
    status = params[:status]
    amount = params[:amount]
    time = params[:time]
    reference = params[:reference]
    verifySign = params[:verifySign]
    note = params[:note]
    begin
    validate(yuansfer_id, status, amount, time, reference, note, verifySign)
    Rails.logger.debug('@response of callback validate' + @response.to_s)
    #render json: @response
    rescue => e
      Rails.logger.error(e)
    end
    @order = Order.find(@param["reference"])
    if @order.status == "paid"
      UserMailer.with(order:@order).order_email.deliver_later
    end
  end

  def ipn
    Rails.logger.debug('params of ipn:' + params.to_s)
    yuansfer_id = params[:yuansferId]
    status = params[:status]
    amount = params[:amount]
    time = params[:time]
    reference = params[:reference]
    note = params[:note]?params[:note]:""
    verifySign = params[:verifySign]
    begin
      validate(yuansfer_id, status, amount, time, reference, note, verifySign)
      Rails.logger.debug('@response of ipn validate' + @response.to_s)
      #render json: @response
    rescue => e
      Rails.logger.error(e)
    end
  end

  private

  def validate(yuansfer_id, status, amount, time, reference, note, verifySign)
    if verifySign != signature(yuansfer_id, status, amount, time, note, reference)
      @response = 'wrong verifySign:' + params.to_s
      @param = params
      Rails.logger.debug('wrong verifySign:' + params.to_s)
    elsif !Order.exists?(reference)
      Rails.logger.debug('no order id:' + reference.to_s)
      Rails.logger.debug('params:' + params.to_s)
      @response = 'no order id:'+reference.to_s+' params:' + params.to_s
      @param = params
    else
      order = Order.find(reference)
      Rails.logger.debug('order before changing status:' + order.to_json)
      if status == 'success'
        order.status = Order.statuses[:paid]
        if order.sub_orders.empty? || order.sub_orders.nil?
          order.create_sub_order
        end
        order.save!
        Rails.logger.debug('order:' + order.to_json)
        @response = 'pay success' + params.to_s
        @param = params
        Rails.logger.debug('response : ' + @response)
      else
        order.status = Order.statuses[:pending]
        order.save!
        Rails.logger.debug('order:' + order.to_json)
        @response = 'try later' + params.to_s
        @param = params
        Rails.logger.debug('response : ' + @response)
      end
      payment_time = DateTime.strptime(time, '%y%m%d%H%M%S')
      Transaction.create({
        order_id: order.id,
        yuansfer_id: yuansfer_id,
        status: status,
        amount: amount,
        payment_time: payment_time,
      })
    end

  end

  def signature(yuansfer_id, status, amount, time, note, reference)
    api_token_md5 = Digest::MD5.hexdigest(Rails.configuration.yuansfer[:api_token])
    if note.empty?
      buf ="amount=#{amount}&reference=#{reference}&status=#{status}&time=#{time}&yuansferId=#{yuansfer_id}&#{api_token_md5}"
    else
      buf ="amount=#{amount}&note=#{note}&reference=#{reference}&status=#{status}&time=#{time}&yuansferId=#{yuansfer_id}&#{api_token_md5}"
    end
    Digest::MD5.hexdigest(buf)
  end

end
