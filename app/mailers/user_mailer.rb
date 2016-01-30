class UserMailer < ApplicationMailer
  def verification_email(user)
    @user = user
    mail(to: @user.email, subject: "Verify Your Email Address")
  end
end
