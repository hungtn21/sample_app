class SessionsController < ApplicationController
  before_action :load_user, only: :create
  before_action :check_authenticate, only: :create
  before_action :check_activated, only: :create

  def new; end

  def create
    handle_login(@user)
    flash[:success] = t(".success", user: @user.name)
    redirect_back_or @user
  end

  def destroy
    log_out
    redirect_to root_path
    flash[:success] = t(".success")
  end

  private

  def load_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user

    flash[:warning] = t("errors.not_found")
    redirect_to root_path
  end

  def check_authenticate
    return if @user&.authenticate(params.dig(:session, :password))

    handle_login_failure and return
  end

  def check_activated
    return if @user.activated

    flash.now[:danger] = t(".not_activated")
    render :new, status: :unprocessable_entity
  end

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

  def handle_login_failure
    flash.now[:danger] = t(".failure")
    render :new, status: :unprocessable_entity
  end
end
