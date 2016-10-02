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
    assert_includes @group.titles, "engineer"
    assert_includes @group.titles, "office manager"
  end

  test "group with 0 users is empty?" do
    assert @group.empty?
  end

  test "group with at least 1 user is not empty?" do
    s = Salary.new(title: "engineer", annual_pay: 110000)

    s.user = @user
    s.group = @group

    s.save!

    refute @group.empty?
  end

  test "group has an accurate average overall" do
    populate_with_salaries

    expected_avg = 86666
    avg = @group.statistics.average_annual_pay
    assert_equal expected_avg, avg
  end

  test "group has an accurate median overall" do
    populate_with_salaries

    expected_median = 95000
    median = @group.statistics.median_annual_pay
    assert_equal expected_median, median
  end

  test "rank_of returns correct rank" do
    populate_with_salaries

    salary = Salary.create(user: @user,
                           group: @group,
                           title: "engineer", 
                           annual_pay: 97000)

    expected_rank = 2
    assert_equal expected_rank, @group.statistics.rank_of(salary)
  end

  test "salaries_by_title returns correct hash" do
    populate_with_salaries

    hash = @group.salaries_by_title
    assert_equal 2, hash.keys.count

    assert hash.has_key?("engineer")
    assert hash.has_key?("office manager")

    assert_equal 2, hash["engineer"].count
    assert_equal 1, hash["office manager"].count
  end

  private
  def populate_with_salaries
    s = Salary.new(title: "engineer", annual_pay: 100000)
    s2 = Salary.new(title: "engineer", annual_pay: 95000)
    s3 = Salary.new(title: "office manager", annual_pay: 65000)

    s.user = User.create(email: "user1@test.com", password: "p@sswrd")
    s.group = @group
    s2.user = User.create(email: "user2@test.com", password: "p@sswrd")
    s2.group = @group
    s3.user = User.create(email: "user3@test.com", password: "p@sswrd")
    s3.group = @group

    s.save!
    s2.save!
    s3.save!
  end
end
