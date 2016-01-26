class SessionsController < ApplicationController
  skip_before_action :authorize

  def create
    email = params[:email]
    password = params[:password]

    if @user = User.find_by_email(email) and @user.authenticate(password)
      session[:user_id] = @user.id
      redirect_to groups_path
    else
      redirect_to login_path, alert: "Invalid Login"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
