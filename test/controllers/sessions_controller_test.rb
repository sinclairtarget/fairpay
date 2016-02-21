class SessionsControllerTest < ActionController::TestCase
  test "can get login" do
    get :new
    assert_response :success
  end

  test "can login" do
    post :create, { email: 'tester@gmail.com', password: 'p@sswrd123' }

    assert_response :redirect
    assert_redirected_to groups_path
  end

  test "can fail login" do
    post :create, { email: 'foo@gmail.com', password: 'foo' }

    assert_response :redirect
    assert_redirected_to login_path
    assert_not_nil flash[:alert]
  end
end
