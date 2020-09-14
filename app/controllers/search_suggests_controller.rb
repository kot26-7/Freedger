class SearchSuggestsController < ApplicationController
  before_action :correct_user_with_user_id

  def index
    keyword = autocomplete_params[:keyword]
    max_limit = autocomplete_params[:suggests_max_num]
    if keyword.present?
      query = @user.products.where('name like ?', "#{keyword}%")
      query = query.limit(max_limit) if max_limit.to_i.positive?
      render json: query.pluck(:name)
    else
      render json: {
        alert: 'Invalid parameter detected, please check parameters',
        data: "keyword: #{keyword}, suggests_max_num: #{max_limit}",
      }, status: :bad_request
    end
  end

  private

  def autocomplete_params
    params.permit(:keyword, :suggests_max_num)
  end

  def correct_user_with_user_id
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to root_path, alert: 'Invalid access detected'
    end
  end
end
