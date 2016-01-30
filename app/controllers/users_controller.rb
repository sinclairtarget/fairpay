class UsersController < ApplicationController
  skip_before_action :authorize

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
      else
        redirect_to new_user_path, alert: user.alert_message
      end
    rescue ActiveRecord::RecordNotUnique 
      alert = "An account with that email address already exists."
      redirect_to new_user_path, alert: alert
    end
  end

  def verify
  end
end
