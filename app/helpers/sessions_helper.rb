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

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	# Logs out the current user.
  def log_out
  	forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
