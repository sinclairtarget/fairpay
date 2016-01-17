class User < ActiveRecord::Base
  validates :email, presence: true, format: { with: /.+@.+/ }
  has_secure_password
end
