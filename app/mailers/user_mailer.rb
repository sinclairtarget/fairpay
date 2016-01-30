class UserMailer < ApplicationMailer
  def verification_email(user)
    @user = user
    mail(to: @user.email, subject: "Verify Your Email Address")
  end

  def invite_email(group, emails)
    @group = group
    mail(to: emails, 
         subject: "A coworker has invited you to share your salary")
  end
end
