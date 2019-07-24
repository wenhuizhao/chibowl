class UserMailer < ApplicationMailer
  default from: 'support@chibowl.com'
  def order_email
    attachments.inline["public_account.jpg"] = File.read("#{Rails.root}/app/assets/images/public_account_small.jpg")
    @order = params[:order]
    @url = url_for(controller: :orders, action: :view, uuid: @order.uuid)
    mail(to: @order.email, subject: I18n.t('mail.order.subject'))
  end
end
