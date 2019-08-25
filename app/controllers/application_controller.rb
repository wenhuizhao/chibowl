class ApplicationController < ActionController::Base
#  protect_from_forgery with: :exception
  protect_from_forgery unless: -> { request.format.json? }
  before_action :set_locale
  include Convert

  def set_locale
    I18n.locale = :zh
  end
end
