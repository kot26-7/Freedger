class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, except: [:index]

  def index
    redirect_to user_path(current_user)
  end

  def show
    if @user.containers.present?
      @data = {}
      @user.containers.includes(:products).each do |container|
        @data.merge!(container.name => container.products.size)
      end
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Update Your Profile successfully'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = 'User deleted'
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end

  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user), alert: 'Invalid access detected'
    end
  end
end
