class SalariesControllerTest < ActionController::TestCase
  setup do
    @user = User.find_by(email: 'tester@gmail.com')
    @user.verified = true
    @user.save!

    @group = Group.find_by(name: 'Test Group')

    @create_params = {
      title: "Engineer",
      salary: { annual_pay: 110000 },
      user_id: @user.id,
      group_id: @group.id
    }
  end

  test "can get new" do
    get :new, nil, { user_id: @user.id }
    assert_response :success
  end

  test "can create salary in empty group" do
    salaries_count_before = @group.salaries.count

    post :create, @create_params, 
      { user_id: @user.id, group_to_join_id: @group.id }

    assert_response :redirect
    assert_redirected_to invite_group_path(@group)

    @group.reload
    assert_equal salaries_count_before + 1, @group.salaries.count
  end

  test "can create salary in non-empty group" do
    some_user = User.new(email: "tester2@gmail.com", password: "p@sswrd123")
    some_user.save!

    existing_salary = Salary.new(title: "Engineer",
                                 annual_pay: 140000,
                                 user_id: some_user.id,
                                 group_id: @group.id)
    existing_salary.save!

    salaries_count_before = @group.salaries.count

    post :create, @create_params, 
      { user_id: @user.id, group_to_join_id: @group.id }

    assert_response :redirect
    assert_redirected_to group_path(@group)

    @group.reload
    assert_equal salaries_count_before + 1, @group.salaries.count
  end
end
