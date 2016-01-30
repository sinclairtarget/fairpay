require 'securerandom'

class UsersController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]

  def new
  end

  def create
    @email = params[:email]
    password = params[:password]
    password_confirm = params[:password_confirm]

    user = User.new(email: @email,
                    password: password,
                    password_confirmation: password_confirm)
    
    begin
      if user.save
        session[:user_id] = user.id
        redirect_to verify_notice_user_path(id: user.id, send_verify: true)
      else
        redirect_to new_user_path, alert: user.alert_message
      end
    rescue ActiveRecord::RecordNotUnique 
      alert = "An account with that email address already exists."
      redirect_to new_user_path, alert: alert
    end
  end

  def verify_notice
    if params[:send_verify] and !@user.verified
      str = SecureRandom.hex(12)
      @user.verification_code = str
      @user.save!
      UserMailer.verification_email(@user).deliver_later
    end
  end

  def verify
  end
end
