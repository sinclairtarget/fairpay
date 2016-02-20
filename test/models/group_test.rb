require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  setup do
    @group = Group.new(name: "Test Group")
    @group.save!

    @user = User.new(email: "test@gmail.com", password: "hello")
    @user.save!
  end

  test "group must have a name" do
    group = Group.new
    assert group.invalid?
    assert group.errors[:name].any?
  end

  test "group must have correct titles" do
    s = Salary.new(title: "Engineer", annual_pay: 100000)
    s2 = Salary.new(title: "Engineer", annual_pay: 95000)
    s3 = Salary.new(title: "Office Manager", annual_pay: 65000)

    s.user = @user
    s.group = @group
    s2.user = @user
    s2.group = @group
    s3.user = @user
    s3.group = @group

    s.save!
    s2.save!
    s3.save!

    assert_equal @group.titles.count, 2
    assert_includes @group.titles, "Engineer"
    assert_includes @group.titles, "Office Manager"
  end

  test "group with 0 users is empty?" do
    assert @group.empty?
  end

  test "group with at least 1 user is not empty?" do
    s = Salary.new(title: "Engineer", annual_pay: 110000)

    s.user = @user
    s.group = @group

    s.save!

    refute @group.empty?
  end
end
