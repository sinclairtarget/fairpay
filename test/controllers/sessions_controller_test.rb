class SessionsControllerTest < ActionController::TestCase
  setup do
    user = User.find_by(email: "anne@test.com")
    @session = { user_id: user.id }

    @login_data = {
      email: "anne@test.com",
      password: "p@sswrd"
    }
  end

  test "can get login" do
    get :new
    assert_response :success
  end

  test "if already logged in, redirect to groups index" do
    get :new, nil, @session

    assert_response :redirect
    assert_redirected_to groups_path
  end

  test "can login" do
    post :create, @login_data

    assert_response :redirect
    assert_redirected_to groups_path
  end

  test "can fail login" do
    post :create, @login_data.merge(email: "foo@test.com")

    assert_response :redirect
    assert_redirected_to login_path
    assert_not_nil flash[:alert]
  end
end
