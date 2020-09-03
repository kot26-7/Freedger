class DeadlineAlertsController < ApplicationController
  before_action :correct_user_with_user_id
  before_action :correct_deadline_alert, only: [:destroy]

  def index
    @deadline_alerts = @user.deadline_alerts.all
  end

  def create
    if @user.deadline_alerts.present?
      @user.deadline_alerts.destroy
    end
    today = Date.today
    products = @user.products.includes(:container)
    products.each do |product|
      if today == product.product_expired_at
        Deadline_alert.create(user_id: @user, container_id: product.container_id, product_id: product.id, action: 'Warning')
      elsif today > product.product_expired_at
        Deadline_alert.create(user_id: @user, container_id: product.container_id, product_id: product.id, action: 'Expired')
      elsif today < product.product_expired_at && today - 3 > product.product_expired_at
        Deadline_alert.create(user_id: @user, container_id: product.container_id, product_id: product.id, action: 'Recommend')
      end
    end
    redirect_to user_deadline_alerts(@user), notice: "#{@user.deadline_alerts} detected"
  end

  def destroy
    @deadline_alert.destroy
    redirect_to user_deadline_alerts(current_user), notice: 'Deleted Successfully'
  end

  private

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
