class GroupsControllerTest < ActionController::TestCase
  setup do
    @user = User.find_by(email: 'tester@gmail.com')
    @user.verified = true
    @user.save!

    @session = { user_id: @user.id }

    @group = Group.find_by(name: 'Test Group')
  end

  test "can get index" do
    get :index, nil, @session
    assert_response :success
  end

  test "can get show" do
    get :show, { id: @group.id }, @session
    assert_response :success
  end
end
