class ContainersController < AuthenticationController
  before_action :authenticate_user!
  before_action :correct_user_with_user_id
  before_action :correct_container, only: [:show, :edit, :update, :destroy]

  def index
    @containers = @user.containers.all.includes(:products)
  end

  def show
    @products = @container.products.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @container = Container.new
  end

  def edit
  end

  def create
    @container = @user.containers.build(container_params)
    if @container.save
      redirect_to user_container_path(@user, @container), notice: 'コンテナが作成されました。'
    else
      render :new
    end
  end

  def update
    if @container.update(container_params)
      redirect_to user_container_path(@user, @container), notice: 'コンテナの情報が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @container.destroy
    redirect_to user_path(current_user), notice: 'コンテナが削除されました。'
  end

  private

  def container_params
    params.require(:container).permit(:name, :position, :description, :image)
  end

  def correct_container
    @container = Container.find(params[:id])
    unless @container.user_id == current_user.id
      redirect_to user_path(current_user), alert: Settings.invalid_access_msg
    end
  end
end
