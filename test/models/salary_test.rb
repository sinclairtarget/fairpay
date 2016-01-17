require 'test_helper.rb'

class SalaryTest < ActiveSupport::TestCase
  test "salary must have a title" do
    salary = Salary.new
    assert salary.invalid?
    assert salary.errors[:title].any?
  end

  test "salary must have an annual pay" do
    salary = Salary.new
    assert salary.invalid?
    assert salary.errors[:annual_pay].any?
  end

  test "annual pay must be an integer" do
    salary = Salary.new(annual_pay: 60000.5)
    assert salary.invalid?
    assert salary.errors[:annual_pay].any?
  end

  test "annual pay must be greater than or equal to zero" do
    salary = Salary.new(annual_pay: -1)
    assert salary.invalid?
    assert salary.errors[:annual_pay].any?
  end

  test "salary must belong to a user" do
    salary = Salary.new
    assert salary.invalid?
    assert salary.errors[:user_id].any?
  end

  test "salary must belong to a group" do
    salary = Salary.new
    assert salary.invalid?
    assert salary.errors[:group_id].any?
  end
end
