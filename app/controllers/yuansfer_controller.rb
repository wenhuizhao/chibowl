class YuansferController < ApplicationController

  def callback
    yuansfer_id = params[:yuansferId]
    status = params[:status]
    amount = params[:amount]
    time = params[:time]
    reference = params[:reference]
    note = params[:note]
    verifySign = params[:verifySign]
    process(yaunsfer_id, status, amount, time, reference, note, verifySign)
  end

  def ipn
    yuansfer_id = params[:yuansferId]
    status = params[:status]
    amount = params[:amount]
    time = params[:time]
    reference = params[:reference]
    note = params[:note]
    verifySign = params[:verifySign]
    process(yaunsfer_id, status, amount, time, reference, note, verifySign)
  end

  private

  def process(yaunsfer_id, status, amount, time, reference, note, verifySign)
    if verifySign != signature(yaunsfer_id, status, amount, time, reference, note)
      Rails.logger.warn('invaliad yuansfer callback:' + params.to_s)
    elsif Order.find(reference).nil?
      Rails.logger.warn('invalid yuansfer callback with order id:#{reference}')
    else
      if status == 'success'
        order = Order.find(reference)
        order.status = Order.statuses[:paid]
        order.save
      end
      payment_time = DateTime.strptime(time, '%y%m/%d%H%M%S')
      Transaction.create({
        order_id: order.id,
        yuansfer_id: yuansfer_id,
        status: status,
        amount: amount,
        payment_time: payment_time,
        note: note,
        transaction_type: :payment
      })
    end

  end

  def signature(yuansfer_id, status, amount, time, reference, note)
    api_token_md5 = Digest::MD5.hexdigest(Rails.configuration.yuansfer[:api_token])
    buf = %q(
    amount=#{amount}&note=#{note}&reference=#{reference}&status=#{status}&time=#{time}&#{api_token}
    )
    Digest::Md5.hexdigest(buf)
  end
end