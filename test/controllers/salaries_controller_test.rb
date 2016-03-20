class SalariesControllerTest < ActionController::TestCase
  setup do
    @user = User.create(email: "tester@test.com",
                        password: "p@sswrd",
                        verified: true)

    @empty_group = Group.find_by(name: "Empty")
    @existing_group = Group.find_by(name: "Existing")
  end

  test "can get new" do
    get :new, nil, { user_id: @user.id }
    assert_response :success
  end

  test "can create salary in empty group" do
    salaries_count_before = @empty_group.salaries.count

    create_params = {
      title: "Engineer",
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
      title: "Engineer",
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
end
