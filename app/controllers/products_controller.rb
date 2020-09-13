class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user_with_user_id, only: [:index]
  before_action :correct_user_with_user_id_and_container_id, except: [:index]
  before_action :correct_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = @user.products.search(params[:search]).order(:name)
    @products = @user.products.tagged_with("#{params[:tag_name]}").order(:name) if params[:tag_name]
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = @container.products.build(product_params)
    if @product.save
      redirect_to user_container_product_path(@product.user_id, @product.container_id, @product),
                  notice: 'Product created Successfully'
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to user_container_product_path(@product.user_id, @product.container_id, @product),
                  notice: 'Update Successfully'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to user_path(current_user), notice: 'Deleted Product Successfully'
  end

  private

  def product_params
    params.require(:product).permit(:name,
                                    :number,
                                    :product_created_at,
                                    :product_expired_at,
                                    :description,
                                    :user_id, :tag_list)
  end

  def correct_user_with_user_id
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to user_path(current_user), alert: 'Invalid access detected'
    end
  end

  def correct_user_with_user_id_and_container_id
    @user = User.find(params[:user_id])
    @container = Container.find(params[:container_id])
    if @user != current_user || @container.user != current_user
      redirect_to user_path(current_user), alert: 'Invalid access detected'
    end
  end

  def correct_product
    @product = Product.find(params[:id])
    if @product.user != @user || @product.container != @container
      redirect_to user_path(current_user), alert: 'Invalid access detected'
    end
  end
end
