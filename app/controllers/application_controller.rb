class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize
  before_action :verification_check

  protected
  def authorize
    unless @user = User.find_by_id(session[:user_id])
      redirect_to login_path
    end
  end

  def verification_check
    if @user and !@user.verified
      redirect_to verification_user_path(@user)
    end
  end
end
