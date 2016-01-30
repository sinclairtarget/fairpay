class UserMailer < ApplicationMailer
  def hello_email(user)
    @user = user
    mail(to: @user.email, subject: "Hello, World!")
  end
end
