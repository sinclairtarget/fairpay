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
    populate_with_salaries

    assert_equal @group.titles.count, 2
    assert_includes @group.titles, "Engineer"
    assert_includes @group.titles, "Office Manager"
  end

  test "titles do not depend on casing" do
    populate_with_salaries

    u = User.new(email: "foo@gmail.com", password: "p@sswrd123")
    u.save!

    s = Salary.new(title: "engineer", annual_pay: 150000)
    s.user = @user
    s.group = @group

    s.save!

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

  test "group has an accurate average overall" do
    populate_with_salaries

    expected_avg = 86666
    avg = @group.average_annual_pay
    assert_equal expected_avg, avg
  end

  test "group has an accurate average for a title" do
    populate_with_salaries

    expected_avg = 97500
    avg = @group.average_annual_pay(title: "Engineer")
    assert_equal expected_avg, avg
  end

  test "average for title does not depend on casing" do
    populate_with_salaries

    expected_avg = 97500
    avg = @group.average_annual_pay(title: "engineer")
    assert_equal expected_avg, avg
  end

  test "group has an accurate median overall" do
    populate_with_salaries

    expected_median = 95000
    median = @group.median_annual_pay
    assert_equal expected_median, median
  end

  test "group has an accurate median for a title" do
    populate_with_salaries

    expected_median = 97500
    median = @group.median_annual_pay(title: "Engineer")
    assert_equal expected_median, median
  end

  test "median for title does not depend on casing" do
    populate_with_salaries

    expected_median = 97500
    median = @group.median_annual_pay(title: "engineer")
    assert_equal expected_median, median
  end

  test "title count returns correct count" do
    populate_with_salaries

    expected_count = 2
    assert_equal expected_count, @group.title_count("Engineer")
  end

  private
  def populate_with_salaries
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
  end
end
