require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "user must have an email" do
    user = User.new
    assert user.invalid?
    assert_not_nil user.errors[:email]
  end

  test "user must have an email with '@' in it" do
    user = User.new(email: "sinclair_at_gmail.com")
    assert user.invalid?
    assert_not_nil user.errors[:email]
  end

  test "user must have a password" do
    user = User.new
    assert user.invalid?
    assert_not_nil user.errors[:password]
  end

  test "user password and confirmation must match" do
    user = User.new(password: "blargh", password_confirmation: "foo")
    assert user.invalid?
    assert_not_nil user.errors[:password_confirmation]
  end
end
