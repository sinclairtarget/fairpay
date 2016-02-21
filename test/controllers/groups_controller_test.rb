class GroupsControllerTest < ActionController::TestCase
  setup do
    @user = User.find_by(email: 'tester@gmail.com')
    @user.verified = true
    @user.save!

    @session = { user_id: @user.id }

    @group = Group.find_by(name: 'Test Group')

    @salary = Salary.new(title: 'Engineer', annual_pay: 110000)
    @salary.user = @user
    @salary.group = @group
    @salary.save!
  end

  test "can get index" do
    get :index, nil, @session
    assert_response :success
  end

  test "can get show" do
    get :show, { id: @group.id }, @session
    assert_response :success

    assert_equal "Engineer", assigns(:title)
  end

  test "can get new" do 
    get :new, nil, @session
    assert_response :success
  end

  test "can create group" do
    assert_difference "Group.count", 1 do
      post :create, { group_name: 'New Group' }, @session
    end

    assert_response :redirect
    assert_redirected_to new_salary_path

    assert_equal Group.last.id, session[:group_to_join_id]
  end

  test "can get invite" do
    get :invite, { id: @group.id }, @session
    assert_response :success
  end

  test "can send invites" do
    assert_difference "ActionMailer::Base.deliveries.size", 1 do
      post :send_invites, 
            { id: @group.id, 
              emails: "invitee@gmail.com, invitee2@gmail.com" },
            @session
    end

    assert_response :redirect
    assert_redirected_to group_path(@group.id)
  end

  test "can get join" do
    get :join, { id: @group.id }
    
    assert_response :redirect
    assert_redirected_to new_salary_path

    assert_equal @group.id.to_s, session[:group_to_join_id]
  end
end
