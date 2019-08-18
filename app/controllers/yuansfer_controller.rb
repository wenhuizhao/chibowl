class YuansferController < ApplicationController
  skip_before_action :verify_authenticity_token

  def test

  end

  def callback
    yuansfer_id = params[:yuansferId]
    status = params[:status]
    amount = params[:amount]
    time = params[:time]
    reference = params[:reference]
    verifySign = params[:verifySign]
    begin
    validate(yuansfer_id, status, amount, time, reference, note, verifySign)
    Rails.logger.debug('@response of validate' + @response.to_json)
    render json: @response
    rescue => e
      Rails.logger.error(e)
    end
  end

  def ipn
    yuansfer_id = params[:yuansferId]
    status = params[:status]
    amount = params[:amount]
    time = params[:time]
    reference = params[:reference]
    note = params[:note]
    verifySign = params[:verifySign]
    begin
      validate(yuansfer_id, status, amount, time, reference, note, verifySign)
      Rails.logger.debug('@response of validate' + @response.to_json)
      render json: @response
    rescue => e
      Rails.logger.error(e)
    end
  end

  private

  def validate(yuansfer_id, status, amount, time, reference, note, verifySign)
    if verifySign != signature(yuansfer_id, status, amount, time, reference)
      @response = 'wrong verifySign:' + params.to_s
      Rails.logger.debug('wrong verifySign:' + params.to_s)
    elsif !Order.exists?(reference)
      Rails.logger.debug('no order id:' + reference.to_s)
      Rails.logger.debug('params:' + params.to_s)
      @response = 'no order id:'+reference.to_s+' params:' + params.to_s
    else
      order = Order.find(reference)
      Rails.logger.debug(order)
      if status == 'success'
        order.status = Order.statuses[:paid]
        order.save!
        Rails.logger.debug('order:' + order.to_json)
        @response = 'pay success'
      else
        order.status = Order.statuses[:pending]
        order.save!
        Rails.logger.debug('order:' + order.to_json)
        @response = 'try later'
      end
      payment_time = DateTime.strptime(time, '%y%m%d%H%M%S')
      Transaction.create({
        order_id: order.id,
        yuansfer_id: yuansfer_id,
        status: status,
        amount: amount,
        payment_time: payment_time
      })
    end

  end

  def signature(yuansfer_id, status, amount, time, reference)
    api_token_md5 = Digest::MD5.hexdigest(Rails.configuration.yuansfer[:api_token])
    buf ="amount=#{amount}&reference=#{reference}&status=#{status}&time=#{time}&yuansferId=#{yuansfer_id}&#{api_token_md5}"
    Digest::MD5.hexdigest(buf)
  end

end
