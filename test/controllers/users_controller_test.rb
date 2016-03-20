class UsersControllerTest < ActionController::TestCase
  setup do
    @user = User.create(email: "tester@test.com",
                        password: "p@sswrd",
                        verification_code: "12345abc")
    @session = { user_id: @user.id }
  end

  test "can get new" do
    get :new
    assert_response :success
  end

  test "can create user and send verification email" do
    email_address = "new@gmail.com"

    assert_difference "ActionMailer::Base.deliveries.size", 1 do
      post :create, { email: email_address, 
                      password: "p@sswrd",
                      password_confirm: "p@sswrd" }
    end

    assert_response :redirect

    user_id = session[:user_id]
    assert_not_nil user_id
    assert_redirected_to verification_user_path(id: user_id)

    verification_email = ActionMailer::Base.deliveries.last
    assert_equal email_address, verification_email.to[0]

    user = User.find(user_id)
    assert_not_nil user.verification_code
    assert has_verification_code(verification_email, user.verification_code),
      "Email should contain verification code."
  end

  test "redirects on duplicate user" do
    post :create, { email: @user.email,
                    password: "p@sswrd",
                    password_confirm: "p@sswrd" }

    assert_response :redirect
    assert_redirected_to new_user_path
    assert_not_nil flash[:alert]
  end

  test "redirects on misentered password" do
    post :create, { email: @user.email,
                    password: "p@sswrd",
                    password_confirm: "no_match" }

    assert_response :redirect
    assert_redirected_to new_user_path
    assert_not_nil flash[:alert]
  end

  test "can get verification" do
    get :verification, { id: @user.id }, @session
    assert_response :success
  end

  test "resends user verification email" do
    assert_difference "ActionMailer::Base.deliveries.size", 1 do
      get :resend_verification, { id: @user.id }, @session
    end
    
    assert_response :redirect
    assert_redirected_to verification_user_path(@user)
    assert_not_nil flash[:notice]

    verification_email = ActionMailer::Base.deliveries.last
    assert_equal @user.email, verification_email.to[0]

    @user.reload
    assert_not_nil @user.verification_code
    assert has_verification_code(verification_email, @user.verification_code),
      "Email should include verification code."
  end

  test "can verify" do
    get :verify, { id: @user.id, code: @user.verification_code }, @session
    assert_response :success

    @user.reload
    assert @user.verified, "User should be verified."
  end

  private
  def has_verification_code(email, code)
    email.text_part.to_s.include? code
  end
end
