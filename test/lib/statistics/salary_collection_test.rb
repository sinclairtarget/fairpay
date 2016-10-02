require 'test_helper.rb'

class SalaryCollectionTest < ActiveSupport::TestCase
  setup do
    @group = Group.create!(name: "Test Group")

    user_data = {
      password: "p@sswrd",
      verified: true
    }

    @alice =User.create!(user_data.merge(email: "alice@tester.com"))
    @bob = User.create!(user_data.merge(email: "bob@tester.com"))
    @cindy = User.create!(user_data.merge(email: "cindy@tester.com"))

    @sal_data = {
      group: @group,
      title: "engineer"
    }

  end

  test "salary collection returns correct median with empty group" do
    assert_equal 0, @group.statistics.median_annual_pay
  end

  test "salary collection returns correct median with one salary" do
    Salary.create!(@sal_data.merge(user: @alice, annual_pay: 90000))

    assert_equal 90000, @group.statistics.median_annual_pay
  end

  test "salary collection returns correct median with two salaries" do
    Salary.create!(@sal_data.merge(user: @alice, annual_pay: 90000))
    Salary.create!(@sal_data.merge(user: @bob, annual_pay: 102000))

    assert_equal 96000, @group.statistics.median_annual_pay
  end

  test "salary collection returns correct median with many salaries" do
    Salary.create!(@sal_data.merge(user: @alice, annual_pay: 90000))
    Salary.create!(@sal_data.merge(user: @bob, annual_pay: 102000))
    Salary.create!(@sal_data.merge(user: @cindy, annual_pay: 120000))
  end
end
