class SessionsControllerTest < ActionController::TestCase
  test "can get login" do
    get :new
    assert_response :success
  end

  test "can login" do
    post :create, { email: "anne@test.com", password: "p@sswrd" }

    assert_response :redirect
    assert_redirected_to groups_path
  end

  test "can fail login" do
    post :create, { email: "foo@test.com", password: "p@sswrd" }

    assert_response :redirect
    assert_redirected_to login_path
    assert_not_nil flash[:alert]
  end
end
