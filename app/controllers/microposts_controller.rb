class MicropostsController < ApplicationController
  before_action :set_micropost, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(destroy)
  before_action :build_micropost_with_image, only: :create

  # GET /microposts or /microposts.json
  def index
    @microposts = Micropost.newest
  end

  # GET /microposts/1 or /microposts/1.json
  def show; end

  # GET /microposts/new
  def new
    @micropost = Micropost.new
  end

  # GET /microposts/1/edit
  def edit; end

  # POST /microposts or /microposts.json
  def create
    if @micropost.save
      flash[:success] = t(".success")
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed.newest,
                                items: Settings.defaults.user.items_per_page
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  # PATCH/PUT /microposts/1 or /microposts/1.json
  def update
    respond_to do |format|
      if @micropost.update(micropost_params)
        format.html do
          redirect_to micropost_url(@micropost),
                      notice: t("microposts.updated")
        end
        format.json {render :show, status: :ok, location: @micropost}
      else
        format.html {render :edit, status: :unprocessable_entity}
        format.json do
          render json: @micropost.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /microposts/1 or /microposts/1.json
  def destroy
    if @micropost.destroy
      flash[:success] = t(".success")
    else
      flash[:danger] = t(".failed")
    end
    redirect_to request.referer || root_url
  end

  private
  def set_micropost
    @micropost = Micropost.find_by(id: params[:id])
    return if @micropost

    flash[:alert] = t("errors.not_found")
    redirect_to microposts_path
  end

  def micropost_params
    params.require(:micropost).permit Micropost::PERMITTED_ATTRIBUTES
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t("microposts.not_found")
    redirect_to request.referer || root_url
  end

  def build_micropost_with_image
    @micropost = current_user.microposts.build(micropost_params)
  end
end
