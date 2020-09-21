require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET home/index' do
    before do
      get root_path
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the :index template' do
      expect(response).to render_template :index
    end

    it 'displayed on correct title' do
      expect(response.body).to include full_title('Home')
    end
  end

  describe 'GET home/about' do
    before do
      get about_path
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the :about template' do
      expect(response).to render_template :about
    end

    it 'displayed on correct title' do
      expect(response.body).to include full_title('About')
    end
  end
end
