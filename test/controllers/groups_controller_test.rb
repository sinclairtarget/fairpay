class GroupsControllerTest < ActionController::TestCase
  setup do
    @user = User.create!(email: "tester@test.com",
                        password: "p@sswrd",
                        verified: true)

    @session = { user_id: @user.id }

    @group = Group.find_by(name: "Existing")

    @salary = Salary.create!(user: @user,
                            group: @group,
                            title: "Engineer", 
                            annual_pay: 110000)
  end

  test "can get index" do
    get :index, nil, @session
    assert_response :success
  end

  test "can get show" do
    get :show, { id: @group.id }, @session
    assert_response :success
  end

  test "cannot get show if not member" do
    imposter = User.find_by(email: "imposter@test.com")
    get :show, { id: @group.id }, { user_id: imposter.id }

    assert_response :forbidden
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

  test "cannot send invites if not member" do
    imposter = User.find_by(email: "imposter@test.com")
    post :send_invites, { id: @group.id, emails: "invitee@gmail.com" },
      { user_id: imposter.id }

    assert_response :forbidden
  end

  test "do not send invites to existing members" do
    assert_difference "ActionMailer::Base.deliveries.size", 1 do
      data = { 
        id: @group.id, 
        emails: "invitee@gmail.com, tester@test.com" 
      }

      post :send_invites, data, @session
    end

    invite_email = ActionMailer::Base.deliveries.last
    assert_equal 1, invite_email.to.count
    assert_equal "invitee@gmail.com", invite_email.to[0]
  end

  test "can get join" do
    get :join, { id: @group.id }
    
    assert_response :redirect
    assert_redirected_to new_salary_path

    assert_equal @group.id.to_s, session[:group_to_join_id]
  end
end
