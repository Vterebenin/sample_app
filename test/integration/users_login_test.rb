require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:michael)
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
    get login_path # 1
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } } #2
    assert is_logged_in? # log in?
    assert_redirected_to @user # check that there is redirect to user page
    follow_redirect! # follow him
    assert_template 'users/show' # check that its the right page
    assert_select "a[href=?]", login_path, count: 0 # there is no link for login?
    assert_select "a[href=?]", logout_path # there is logout link
    assert_select "a[href=?]", user_path(@user) # there is profile link
    delete logout_path # destroy session / logout 
    assert_not is_logged_in? # check that
    assert_redirected_to root_url # if not logged in there is redirect to root
    delete logout_path # simulate destroy for the second window
    follow_redirect! # follow redirect 
    assert_select "a[href=?]", login_path # there is login link
    assert_select "a[href=?]", logout_path,      count: 0 # and no logout link
    assert_select "a[href=?]", user_path(@user), count: 0 # and no profile link
  end

  test "valid signup information" do
    get signup_path # there is sign up
    assert_difference 'User.count', 1 do # with this data passed, user will be created
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    #assert_template 'users/show' 
    #assert is_logged_in? # Returns true if a test user is logged in.
  end

  

  test "login with remembering" do
  	# Log in to set the cookie.
  	log_in_as(@user, remember_me: '1')
  	assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
  	#log in to set the cookie
  	log_in_as(@user, remember_me: '1')
  	# Log in again and verify that the cookie is deleted.
  	log_in_as(@user, remember_me: '0')
  	assert_empty cookies['remember_token']
  end
end
