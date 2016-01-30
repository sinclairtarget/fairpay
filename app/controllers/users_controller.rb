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
        send_verification_email_to user
        redirect_to verification_user_path(user)
      else
        redirect_to new_user_path, alert: user.alert_message
      end
    rescue ActiveRecord::RecordNotUnique 
      alert = "An account with that email address already exists."
      redirect_to new_user_path, alert: alert
    end
  end

  # email verificiation
  def verification
  end

  def resend_verification
    send_verification_email_to @user

    notice = "Email sent. Please be sure to check your spam folder."
    redirect_to verification_user_path(@user), notice: notice
  end

  def verify
  end

  protected
  def send_verification_email_to(user)
    str = SecureRandom.hex(12)
    user.verification_code = str
    user.save!
    UserMailer.verification_email(user).deliver_later
  end
end
