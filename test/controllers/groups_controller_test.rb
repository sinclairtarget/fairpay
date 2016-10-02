require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
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

    Salary.create!(
      salary_data.merge(user: @user, annual_pay: 110000)
    )
    Salary.create!(
      salary_data.merge(user: alice, annual_pay: 102000)
    )
    Salary.create!(
      salary_data.merge(user: bob, annual_pay: 96000)
    )
    Salary.create!(
      salary_data.merge(user: cindy, title: "Associate", annual_pay: 65000)
    )

    @imposter = User.create!(
      email: "imposter@test.com",
      password: "p@sswrd",
      verified: true
    )
  end

  test "index redirects to show" do
    get :index, nil, @session
    assert_redirected_to group_path(@group.id)
  end

  test "index redirects to new group path if user does not have any groups" do
    new_user = User.create!(email: "newuser@test.com",
                            password: "p@sswrd",
                            verified: true)

    session = { user_id: new_user.id }

    get :index, nil, session
    assert_redirected_to new_group_path
  end

  test "can get show" do
    get :show, { id: @group.id }, @session
    assert_response :success
  end

  test "cannot get show if not member" do
    get :show, { id: @group.id }, { user_id: @imposter.id }

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

  test "can get invite" do
    get :invite, { id: @group.id }, @session
    assert_response :success
  end

  test "cannot get invite if not member" do
    get :invite, { id: @group.id }, { user_id: @imposter.id} 

    assert_response :forbidden
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
    post :send_invites, { id: @group.id, emails: "invitee@gmail.com" },
      { user_id: @imposter.id }

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
    get :join, { id: @group.id }, @session
    
    assert_response :redirect
    assert_redirected_to new_salary_path

    assert_equal @group.id.to_s, session[:group_to_join_id]
  end
end
