class DeadlineAlertsController < ApplicationController
  before_action :correct_user_with_user_id
  before_action :correct_deadline_alert, only: [:destroy]

  def index
    deadline_alerts = @user.deadline_alerts.all.includes(:container, :product)
    @warning_deadline_alerts = deadline_alerts.where(action: Settings.deadline_warning)
    @expired_deadline_alerts = deadline_alerts.where(action: Settings.deadline_expired)
    @recommend_deadline_alerts = deadline_alerts.where(action: Settings.deadline_recommend)
  end

  def create
    if @user.deadline_alerts.present?
      @user.deadline_alerts.destroy_all
    end
    today = Date.current
    @user.products.all.each do |product|
      if today == product.product_expired_at
        DeadlineAlert.create(user_id: product.user_id,
                             container_id: product.container_id,
                             product_id: product.id, action: Settings.deadline_warning)
      elsif today > product.product_expired_at
        DeadlineAlert.create(user_id: product.user_id,
                             container_id: product.container_id,
                             product_id: product.id, action: Settings.deadline_expired)
      elsif today < product.product_expired_at && today + 3 > product.product_expired_at
        DeadlineAlert.create(user_id: product.user_id,
                             container_id: product.container_id,
                             product_id: product.id, action: Settings.deadline_recommend)
      end
    end
    redirect_to user_deadline_alerts_path(@user), notice: 'Searched Successfully'
  end

  def destroy
    @deadline_alert.destroy
    redirect_to user_deadline_alerts_path(current_user), notice: 'Deleted Successfully'
  end

  private

  def correct_user_with_user_id
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to user_path(current_user), alert: 'Invalid access detected'
    end
  end

  def correct_deadline_alert
    @deadline_alert = DeadlineAlert.find(params[:id])
    unless @deadline_alert.user_id == @user.id
      redirect_to user_path(current_user), alert: 'Invalid access detected'
    end
  end
end
