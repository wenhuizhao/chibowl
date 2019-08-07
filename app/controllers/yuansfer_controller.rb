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
    note = params[:note]
    verifySign = params[:verifySign]
    validate(yuansfer_id, status, amount, time, reference, note, verifySign)

  end

  def ipn
    yuansfer_id = params[:yuansferId]
    status = params[:status]
    amount = params[:amount]
    time = params[:time]
    reference = params[:reference]
    note = params[:note]
    verifySign = params[:verifySign]
    validate(yuansfer_id, status, amount, time, reference, note, verifySign)
  end

  private

  def validate(yuansfer_id, status, amount, time, reference, note, verifySign)
    if verifySign != signature(yuansfer_id, status, amount, time, reference, note)
      @response = 'invaliad yuansfer callback:' + params.to_s
      # Rails.logger.warn('invaliad yuansfer callback:' + params.to_s)
    elsif !Order.exists?(reference)
      # Rails.logger.warn('invalid yuansfer callback with order id:#{reference}')
      @response = 'invalid yuansfer callback with order id:'+reference.to_s
    else
      order = Order.find(reference)
      if status == 'success'
        order.status = Order.statuses[:paid]
        order.save
        @response = 'pay success'
      else
        order.status = Order.statuses[:pending]
        order.save
        @response = 'try later'
      end
      payment_time = DateTime.strptime(time, '%y%m%d%H%M%S')
      Transaction.create({
        order_id: order.id,
        yuansfer_id: yuansfer_id,
        status: status,
        amount: amount,
        payment_time: payment_time,
        #note: note,
        #transaction_type: :payment
      })
    end

  end

  def signature(yuansfer_id, status, amount, time, reference, note)
    api_token_md5 = Digest::MD5.hexdigest(Rails.configuration.yuansfer[:api_token])
    buf ="amount=#{amount}&note=#{note}&reference=#{reference}&status=#{status}&time=#{time}&yuansfer_id=#{yuansfer_id}&#{api_token_md5}"
    Digest::MD5.hexdigest(buf)
  end

end
