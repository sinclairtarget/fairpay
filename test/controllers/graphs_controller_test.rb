require 'test_helper'

class GraphsControllerTest < ActionController::TestCase
  setup do
    @group = Group.create!(name: "Test Group")

    user_data = {
      password: "p@sswrd",
      verified: true
    }

    @user = User.create!(user_data.merge(email: "tester@test.com"))
    alice = User.create!(user_data.merge(email: "alice@test.com"))
    bob = User.create!(user_data.merge(email: "bob@test.com"))
    cindy = User.create!(user_data.merge(email: "cindy@test.com"))

    @session = { user_id: @user.id }

    salary_data = {
      group: @group,
      title: "Engineer"
    }

    @salary = Salary.create!(
      salary_data.merge(user: @user, annual_pay: 110000)
    )
    @alice_sal = Salary.create!(
      salary_data.merge(user: alice, annual_pay: 102000)
    )
    @bob_sal = Salary.create!(
      salary_data.merge(user: bob, annual_pay: 96000)
    )
    @cindy_sal = Salary.create!(
      salary_data.merge(user: cindy, title: "Associate", annual_pay: 65000)
    )

    @imposter = User.create!(
      email: "imposter@test.com",
      password: "p@sswrd",
      verified: true
    )
  end

  test "distribution returns correct data" do
    get :distribution, { group_id: @group.id }, @session

    assert_response :success
  end

  test "distribution returns correct data for specific title" do
    get :distribution, { group_id: @group.id, title: 'Associate' }, @session

    assert_response :success
  end

  test "scatter returns correct data" do
    get :scatter, { group_id: @group.id }, @session

    assert_response :success
    
    parsed_resp = JSON.parse(@response.body)

    expected = [
      [1, @cindy_sal.annual_pay],
      [2, @bob_sal.annual_pay],
      [3, @alice_sal.annual_pay],
      [4, @salary.annual_pay]
    ]
    parsed_resp.each_with_index do |salary_tuple, i|
      expected_tuple = expected[i]
      assert are_equal_tuples(salary_tuple, expected_tuple), 
        "Expected #{expected_tuple} but got #{salary_tuple}"
    end
  end

  test "scatter returns correct data for specific title" do
    get :scatter, { group_id: @group.id, title: "Associate" }, @session

    assert_response :success

    parsed_resp = JSON.parse(@response.body)

    expected = [
      [1, @cindy_sal.annual_pay]
    ]

    assert_equal expected, parsed_resp
  end

  test "title_medians returns correct data" do
    get :title_medians, { group_id: @group.id }, @session

    assert_response :success

    parsed_resp = JSON.parse(@response.body)

    expected = [
      ["Associate", 65000],
      ["Engineer", 102000]
    ]

    assert_equal expected, parsed_resp
  end

  private
  def are_equal_tuples(a ,b)
    a[0] == b[0] && a[1] == b[1]
  end
end
