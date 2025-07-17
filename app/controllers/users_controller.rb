class UsersController < ApplicationController
  before_action :load_user, only: :show

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t(".success")
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("errors.not_found")
    redirect_to root_path
  end
end
