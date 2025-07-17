module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= find_user_from_cookies || find_user_from_session
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    forget(current_user) if current_user
    session.delete(:user_id) if session[:user_id]
    session.delete(:session_token) if session[:session_token]
    @current_user = nil
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user? user
    current_user == user
  end

  private

  def find_user_from_cookies
    user_id = cookies.signed[:user_id]
    return unless user_id

    user = User.find_by(id: user_id)
    return unless user&.authenticated?(:remember, cookies[:remember_token])

    log_in(user)
    user
  end

  def find_user_from_session
    user_id = session[:user_id]
    token = session[:session_token]
    return unless user_id && token

    user = User.find_by(id: user_id)
    user if user&.authenticated?(:remember, token)
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
