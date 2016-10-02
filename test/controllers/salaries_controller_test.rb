require 'test_helper' 

class SalariesControllerTest < ActionController::TestCase
  setup do
    @user = User.create!(email: "tester@test.com",
                         password: "p@sswrd",
                         verified: true)

    @another_user = User.create!(email: "another_tester@test.com",
                                 password: "p@sswrd",
                                 verified: true)

    @empty_group = Group.create!(name: "Empty")
    @existing_group = Group.create!(name: "Existing")

    Salary.create!(title: "product manager",
                   annual_pay: 105000,
                   user: @another_user,
                   group: @existing_group)
  end

  test "can get new" do
    get :new, nil, { user_id: @user.id, group_to_join_id: @empty_group.id }
    assert_response :success
  end

  test "can create salary in empty group" do
    salaries_count_before = @empty_group.salaries.count

    create_params = {
      title: "engineer",
      salary: { annual_pay: 110000 },
      user_id: @user.id,
      group_id: @empty_group.id
    }

    post :create, create_params, 
      { user_id: @user.id, group_to_join_id: @empty_group.id }

    assert_response :redirect
    assert_redirected_to invite_group_path(@empty_group)

    @empty_group.reload
    assert_equal salaries_count_before + 1, @empty_group.salaries.count
  end

  test "can create salary in non-empty group" do
    salaries_count_before = @existing_group.salaries.count

    create_params = {
      title: "engineer",
      salary: { annual_pay: 110000 },
      user_id: @user.id,
      group_id: @existing_group.id
    }

    post :create, create_params, 
      { user_id: @user.id, group_to_join_id: @existing_group.id }

    assert_response :redirect
    assert_redirected_to group_path(@existing_group)

    @existing_group.reload
    assert_equal salaries_count_before + 1, @existing_group.salaries.count
  end

  test "can update salary" do
    salary = Salary.create!(
      title: "engineer",
      annual_pay: 110000,
      user_id: @user.id,
      group_id: @empty_group.id
    )

    put :update, { id: salary.id, title: "clown", annual_pay: 35000 }, 
      { user_id: @user.id }

    assert_response :redirect
    assert_redirected_to group_path(@empty_group)

    salary.reload

    assert_equal "clown", salary.title
    assert_equal 35000, salary.annual_pay
  end

  test "can destroy salary" do
    salary = Salary.create!(
      title: "engineer",
      annual_pay: 110000,
      user_id: @user.id,
      group_id: @existing_group.id
    )

    @existing_group.reload
    salaries_count_before = @existing_group.salaries.count

    delete :destroy, { id: salary.id }, { user_id: @user.id }

    assert_response :redirect
    assert_redirected_to groups_path

    @existing_group.reload
    assert_equal salaries_count_before - 1, @existing_group.salaries.count
  end

  test "cannot destroy another user's salary" do
    other_user = User.create!(
      email: "other@test.com",
      password: "p@sswrd",
      verified: true
    )

    salary = Salary.create!(
      title: "engineer",
      annual_pay: 110000,
      user_id: other_user.id,
      group_id: @empty_group.id
    )

    delete :destroy, { id: salary.id }, { user_id: @user.id }

    assert_response :forbidden
  end
end
