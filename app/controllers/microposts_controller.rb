class MicropostsController < ApplicationController
  before_action :set_micropost, only: %i(show edit update destroy)

  # GET /microposts or /microposts.json
  def index
    @microposts = Micropost.recent
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
    @micropost = Micropost.new(micropost_params)

    respond_to do |format|
      if @micropost.save
        format.html do
          redirect_to micropost_url(@micropost),
                      notice: t("microposts.created")
        end
        format.json {render :show, status: :created, location: @micropost}
      else
        format.html {render :new, status: :unprocessable_entity}
        format.json do
          render json: @micropost.errors,
                 status: :unprocessable_entity
        end
      end
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
    respond_to do |format|
      if @micropost.destroy
        format.html do
          redirect_to microposts_url,
                      notice: t(".success")
        end
        format.json {head :no_content}
      else
        format.html do
          redirect_to microposts_url,
                      alert: t(".failed")
        end
        format.json do
          render json: @micropost.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_micropost
    @micropost = Micropost.find_by(id: params[:id])
    return if @micropost

    flash[:alert] = t("errors.not_found")
    redirect_to microposts_path
  end

  # Only allow a list of trusted parameters through.
  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
