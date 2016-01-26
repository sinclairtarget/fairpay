class User < ActiveRecord::Base
  validates :email, presence: true, format: { with: /.+@.+/ }
  has_many :salaries, dependent: :destroy
  has_many :groups, through: :salaries
  has_secure_password

  def alert_message
    if errors[:email].any?
      "You must enter a valid email address."
    elsif errors[:password].any?
      "You must enter a valid password."
    elsif errors[:password_confirmation].any?
      "You did not enter matching passwords."
    else
      ""
    end
  end
end
