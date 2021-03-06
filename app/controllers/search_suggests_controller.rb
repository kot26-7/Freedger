class SearchSuggestsController < AuthenticationController
  before_action :authenticate_user!
  before_action :correct_user_with_user_id

  def index
    keyword = autocomplete_params[:keyword]
    max_limit = autocomplete_params[:suggests_max_num]
    if @user.products.present?
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
    else
      render json: {
        alert: 'Has no products, please create any products',
      }, status: :bad_request
    end
  end

  private

  def autocomplete_params
    params.permit(:keyword, :suggests_max_num)
  end
end
