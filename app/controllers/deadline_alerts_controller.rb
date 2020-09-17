class DeadlineAlertsController < ApplicationController
  before_action :correct_user_with_user_id
  before_action :correct_deadline_alert, only: [:destroy]

  def index
    deadline_alerts = @user.deadline_alerts.all.includes(:container, :product)
    @alerts = deadline_alerts.order(:action).page(params[:page]).per(12)
    warning = deadline_alerts.where(action: Settings.deadline_warning)
    expired = deadline_alerts.where(action: Settings.deadline_expired)
    recommend = deadline_alerts.where(action: Settings.deadline_recommend)
    @data = {
      'Expired' => expired.size,
      'Warning' => warning.size,
      'Recommend' => recommend.size,
    }
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @user.deadline_alerts.destroy_all if @user.deadline_alerts.present?
    today = Date.current
    @user.container_products.all.each do |product|
      prdct_date = product.product_expired_at
      if today == prdct_date
        DeadlineAlert.create(user_id: product.user_id,
                             container_id: product.container_id,
                             product_id: product.id, action: Settings.deadline_warning)
      elsif today > prdct_date
        DeadlineAlert.create(user_id: product.user_id,
                             container_id: product.container_id,
                             product_id: product.id, action: Settings.deadline_expired)
      elsif today < prdct_date && today + Settings.deadline_delay >= prdct_date
        DeadlineAlert.create(user_id: product.user_id,
                             container_id: product.container_id,
                             product_id: product.id, action: Settings.deadline_recommend)
      end
    end
    redirect_to user_deadline_alerts_path(@user), notice: 'Searched Successfully'
  end

  def destroy
    @deadline_alert.destroy
    deadline_alerts = @user.deadline_alerts.all.includes(:container, :product)
    @alerts = deadline_alerts.order(:action).page(params[:page]).per(12)
    respond_to do |format|
      format.html
      format.js
    end
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
