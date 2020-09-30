class AuthenticationController < ApplicationController
  protected

  def correct_user_with_user_id
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to user_path(current_user), alert: Settings.invalid_access_msg
    end
  end

  def correct_user_with_user_id_and_container_id
    @user = User.find(params[:user_id])
    @container = Container.find(params[:container_id])
    if @user != current_user || @container.user != current_user
      redirect_to user_path(current_user), alert: Settings.invalid_access_msg
    end
  end
end
