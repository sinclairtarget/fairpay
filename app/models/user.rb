class User < ActiveRecord::Base
  validates :email, presence: true, format: { with: /.+@.+/ }
  has_many :salaries, dependent: :destroy
  has_many :groups, through: :salaries
  has_secure_password
end
