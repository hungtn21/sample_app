class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)
  before_action :check_empty_password, only: :update
  before_action :load_user_from_password_reset_params, only: :create
  
  # GET /password_resets/new
  def new; end

  # GET /password_resets/:id/edit
  def edit; end

  # POST /password_resets
  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t(".success")
    redirect_to root_url
  end

  # PATCH/PUT /password_resets/:id
  def update
    if @user.update(user_params)
      @user.send_password_reset_confirmation_email
      @user.update_column(:reset_digest, nil)
      flash[:success] = t(".success")
      redirect_to root_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def load_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t(".errors.not_found")
    redirect_to root_url
  end

  def load_user_from_password_reset_params
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    return if @user.present?

    flash.now[:danger] = t(".errors.not_found")
    render :new, status: :unprocessable_entity
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t(".errors.inactivated")
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t(".errors.expired")
    redirect_to new_password_reset_url
  end

  def check_empty_password
    return if user_params[:password].present?

    @user.errors.add(:password, t(".errors.empty_password"))
    render :edit, status: :unprocessable_entity
  end
end
