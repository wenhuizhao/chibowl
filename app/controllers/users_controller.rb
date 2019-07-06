class UsersController < ApplicationController
    def profile_show
        @user = current_user
    end

    def setting 
        @user = current_user
    end

    def update_setting
        @user = current_user
        @user.update(first_name: params[:user][:first_name],last_name: params[:user][:last_name])
        redirect_to(:action=>'profile_show')
    end
end