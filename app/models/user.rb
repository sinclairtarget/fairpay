# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  email             :string(255)
#  password_digest   :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  verified          :boolean          default(FALSE)
#  verification_code :string(255)
#

class User < ActiveRecord::Base
  validates :email, presence: true, format: { with: /\A[^@]+@[^@]+\z/ }
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

  def username
    email.split('@').first
  end
end
