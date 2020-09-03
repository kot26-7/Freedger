class DeadlineAlertsController < ApplicationController
  before_action :correct_user_with_user_id
  before_action :correct_deadline_alert, only: [:destroy]

  def index
  end

  def create
  end

  def destroy
  end

  private

  def product_params
    params.require(:deadline_alert).permit(:action)
  end

  def correct_user_with_user_id
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to user_path(current_user), alert: 'Invalid access detected'
    end
  end

  def correct_deadline_alert
    @deadline_alert = Deadline_alert.find(params[:id])
    unless @deadline_alert.user_id == @user.id
      redirect_to user_path(current_user), alert: 'Invalid access detected'
    end
  end
end
