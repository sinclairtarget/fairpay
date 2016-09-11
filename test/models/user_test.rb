require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user_data = {
      email: "tester@test.com",
      password: "p@sswrd",
      verified: true
    }
  end

  test "user must have an email" do
    user = User.new
    assert user.invalid?
    assert user.errors[:email].any?
  end

  test "user must have an email with '@' in it" do
    user = User.new(email: "sinclair_at_gmail.com")
    assert user.invalid?
    assert user.errors[:email].any?
  end

  test "user must have an email with only one '@' in it" do
    user = User.new(email: "sinclair@home@gmail.com")
    assert user.invalid?
    assert user.errors[:email].any?
  end

  test "user must have a password" do
    user = User.new
    assert user.invalid?
    assert user.errors[:password].any?
  end

  test "user password and confirmation must match" do
    user = User.new(password: "blargh", password_confirmation: "foo")
    assert user.invalid?
    assert user.errors[:password_confirmation].any?
  end

  test "username is user email without domain" do
    user = User.new(@user_data)
    assert_equal "tester", user.username
  end
end
