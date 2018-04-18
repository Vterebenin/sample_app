require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:Valentine)
	end
  # 1. Visit the login path.
	# 2. Verify that the new sessions form renders properly.
	# 3. Post to the sessions path with an invalid params hash.
	# 4. Verify that the new sessions form gets re-rendered and that a flash message appears.
	# 5. Visit another page (such as the Home page).
	# 6. Verify that the flash message doesn’t appear on the new page.
	test "login with invalid information" do 
		get login_path # 1
		assert_template 'sessions/new' # 2
		post login_path, params: { session: { email: "", password: "" } } # 3
		assert_template 'sessions/new' # 4
		assert_not flash.empty? # 4
		get root_path # 5
		assert flash.empty? # 6
	end

	# 1. Visit the login path.
	# 2. Post valid information to the sessions path.
	# 3. Verify that the login link disappears.
	# 4. Verify that a logout link appears
	# 5. Verify that a profile link appears.
	test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
