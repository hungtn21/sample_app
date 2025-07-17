class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :load_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)
  # GET /users
  def index
    @pagy, @users = pagy(User.recent,
                         items: Settings.defaults.user.items_per_page,
                         page: params[:page], items_param: false)
  end

  # GET /users/:id
  def show; end

  # POST /signup
  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t(".check_email")
      redirect_to @user, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /users/:id/edit
  def edit; end

  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      flash[:success] = t(".updated")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    if @user.destroy
      flash[:success] = t(".success")
    else
      flash[:danger] = t(".failed")
    end
    redirect_to users_path
  end

  # GET /signup
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

  def logged_in_user
    return if logged_in?

    flash[:danger] = t(".errors.not_logged_in")
    store_location
    redirect_to login_path
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t(".errors.not_authorized")
    redirect_to root_path
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t(".errors.not_authorized")
    redirect_to root_path
  end
end
