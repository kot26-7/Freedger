require 'rails_helper'

RSpec.describe 'SearchSuggests', type: :request do
  let!(:user) { create(:user) }
  let!(:container) { create(:container) }
  let(:json_res) { JSON.parse(response.body) }

  describe 'GET search suggests' do
    context 'signin user and has products' do
      let!(:products) { create_list(:product, 6) }
      let!(:product_warning) { create(:product_warning) }

      before do
        sign_in user
        get root_path
      end

      it 'returns http success' do
        get user_search_suggests_path(user_id: user.id, keyword: 'p', suggests_max_num: 5)
        expect(response).to have_http_status(:success)
      end

      it 'returns res_body correctly' do
        get user_search_suggests_path(user_id: user.id, keyword: 'p', suggests_max_num: 5)
        expect(json_res).to eq products.take(5).pluck(:name)
        expect(json_res).not_to include products.last.name
      end

      it 'returns res_body correctly without suggests_max_num' do
        get user_search_suggests_path(user_id: user.id), params: { keyword: 'p' }
        expect(json_res).to eq products.pluck(:name)
        expect(json_res).not_to include product_warning.name
      end
    end

    context 'keyword is nil' do
      let!(:products) { create_list(:product, 6) }

      before do
        sign_in user
        get root_path
      end

      it 'returns http bad_request' do
        get user_search_suggests_path(user_id: user.id, keyword: nil, suggests_max_num: 5)
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns res_body correctly' do
        get user_search_suggests_path(user_id: user.id, keyword: nil, suggests_max_num: 5)
        expect(json_res['alert']).to eq 'Invalid parameter detected, please check parameters'
        expect(json_res['data']).to eq 'keyword: , suggests_max_num: 5'
      end
    end

    context 'signin user and has no products' do
      before do
        sign_in user
        get root_path
      end

      it 'returns http bad_request' do
        get user_search_suggests_path(user_id: user.id, keyword: 'p', suggests_max_num: 5)
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns res_body correctly' do
        get user_search_suggests_path(user_id: user.id, keyword: 'p', suggests_max_num: 5)
        expect(json_res['alert']).to eq 'Has no products, please create any products'
      end
    end

    context 'not signin user' do
      let!(:products) { create_list(:product, 6) }

      before do
        get root_path
      end

      it 'returns http found' do
        get user_search_suggests_path(user_id: user.id, keyword: 'p', suggests_max_num: 5)
        expect(response).to have_http_status(:found)
      end

      it 'redirect_to root_path' do
        get user_search_suggests_path(user_id: user.id, keyword: 'p', suggests_max_num: 5)
        expect(response).to redirect_to root_path
      end
    end
  end
end
