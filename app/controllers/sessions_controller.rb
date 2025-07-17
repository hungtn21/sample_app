class SessionsController < ApplicationController
  # GET /login
  def new; end

  # POST /login
  def create
    user = User.find_by(email: params.dig(:session, :email)&.downcase)
    if user&.authenticate(params.dig(:session, :password))
      handle_login(user)
      flash[:success] = t(".success", user: user.name)
      redirect_back_or user
    else
      flash.now[:danger] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /logout
  def destroy
    log_out
    redirect_to root_path
    flash[:success] = t(".success")
  end

  private

  def handle_login user
    return remember(user) if remember_me?

    log_in(user)
    set_session_token(user)
  end

  def remember_me?
    params.dig(:session,
               :remember_me) == Settings.defaults.remember_me_enabled.to_s
  end

  def set_session_token user
    user.remember
    session[:session_token] = user.remember_token
  end
end
