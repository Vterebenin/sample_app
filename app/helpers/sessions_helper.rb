module SessionsHelper
	# log in the user
	def log_in(user)
		session[:user_id] = user.id
	end

	# Remember a user with a persistent session
	def remember(user)
		user.remember # create a remember_digest
		cookies.permanent.signed[:user_id] = user.id # associate user_id in cookies with users id
		cookies.permanent[:remember_token] = user.remember_token # associate remember_token to the cookies remember_token
	end

	# Returns true if the given user is the current user
	def current_user?(user)
		user == current_user		
	end
	
	# Returns the user corresponding to the remember token cookie.
	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: session[:user_id])
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
							
	end

	# Returns true or false depends of cookie in browser
	def logged_in?
		!current_user.nil?
	end

	# destroy cookies and remember digest
	def forget(user)
		user.forget # user.update_attribute(:remember_digest, nil)
		cookies.delete(:user_id) # destroy cookies
		cookies.delete(:remember_token)
	end

	# Logs out the current user.
  def log_out
  	forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
