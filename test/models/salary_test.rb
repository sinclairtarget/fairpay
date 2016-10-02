require 'test_helper.rb'

class SalaryTest < ActiveSupport::TestCase
  test "salary must have a title" do
    salary = Salary.new
    assert salary.invalid?
    assert salary.errors[:title].any?
  end

  test "salary title must be lowercase" do
    salary = Salary.new(title: "Managing Director")
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

  test "salary must have default hours per week" do
    salary = Salary.new
    assert_not_nil salary.hours_per_week
  end

  test "hourly wage must equal annual pay over hours per year" do
    salary = Salary.new(title: "engineer", 
                        annual_pay: 110000, 
                        hours_per_week: 40)
    assert_in_delta salary.hourly_wage, 52.885
  end

  test "salary must equal hourly wage times hours per year" do
    salary = Salary.new(title: "engineer",
                        hourly_wage: 52.885,
                        hours_per_week: 40)
    assert_in_delta salary.annual_pay, 110000, 0.1
  end

#  test "hours per week cannot be changed on a persisted salary" do
#    user = User.new(email: "test@gmail.com", password: "test")
#    group = Group.new(name: "test group")
#    user.save!
#    group.save!
#
#    salary = Salary.new(title: "Engineer", hourly_wage: 50)
#    salary.user = user
#    salary.group = group
#
#    salary.save!
#    salary.hours_per_week = 45
#
#    assert salary.invalid?
#    assert salary.errors[:base].any?
#  end

  test "no group can have two salaries for the same user" do
    user = User.create!(email: "test@gmail.com", password: "p@sswrd")
    group = Group.create!(name: "Test Group")

    salary = Salary.create!(title: "engineer",
                           annual_pay: 110000,
                           user: user,
                           group: group)

    assert_raise ActiveRecord::RecordNotUnique do
      salary2 = Salary.create!(title: "manager",
                               annual_pay: 110000,
                               user: user,
                               group: group)

    end
  end

  test "last salary destroyed in a group destroys the group" do
    user = User.create!(
      email: "test@test.com", 
      password: "p@sswrd",
      verified: true
    )

    group = Group.create!(name: "Test Group")
    group_id = group.id

    salary = Salary.create!(
      title: "manager",
      annual_pay: 110000,
      user: user,
      group: group
    )

    salary.destroy!

    assert_nil Group.find_by(id: group_id)
  end
end
