require 'securerandom'

class UsersController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]
  skip_before_action :verification_check, 
    only: [:verification, :resend_verification, :verify]

  def new
  end

  def create
    @email = params[:email]
    password = params[:password]
    password_confirm = params[:password_confirm]

    user = User.new(email: @email,
                    password: password,
                    password_confirmation: password_confirm,
                    verification_code: random_verification_code)
    
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
    unless @user.verification_code
      @user.verification_code = random_verification_code 
      @user.save!
    end

    send_verification_email_to @user

    notice = "Email sent. Please be sure to check your spam folder."
    redirect_to verification_user_path(@user), notice: notice
  end

  def verify
    if params[:code] and params[:code] == @user.verification_code
      @user.verified = true
      @user.save!

      if session[:group_to_join_id].present?
        @group = Group.find(session[:group_to_join_id])
      end
    end
  end

  protected
  def random_verification_code
    SecureRandom.hex(12)
  end

  def send_verification_email_to(user)
    UserMailer.verification_email(user).deliver_later
  end
end
