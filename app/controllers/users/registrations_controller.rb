class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json, :html
  def create
    begin
      super
    rescue ActiveRecord::RecordNotUnique
      user = User.find_by_email(params[:user][:email])
      if user.present?
        if user.valid_password?(params[:user][:password])
          sign_in(:user, user)
          respond_with user, :location=>after_sign_in_path_for(user)
        else
          warden.custom_failure!
          render :json => {error: 'Email is already registered'}, :status=>422
        end
      else
        super
      end
    end
  end

  private
  def sign_up_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation,
      :current_password)
  end
end
