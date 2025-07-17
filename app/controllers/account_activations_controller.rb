class AccountActivationsController < ApplicationController
  before_action :load_user, only: :edit
  before_action :check_authentication, only: :edit

  # GET /account_activations/:id/edit
  def edit
    @user.activate
    handle_login(@user)
    flash[:success] = t(".activated")
    redirect_to @user
  end

  private

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:warning] = t("errors.not_found")
    redirect_to root_path
  end

  def handle_login user
    session[:user_id] = user.id
    session_token = User.new_token
    session[:session_token] = session_token
    user.update_column(:remember_digest, User.digest(session_token))
  end

  def check_authentication
    return if !@user.activated && @user.authenticated?(:activation, params[:id])

    flash[:danger] = t(".invalid_activation_link")
    redirect_to root_url
  end
end
