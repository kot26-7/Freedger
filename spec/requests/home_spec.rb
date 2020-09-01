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
end
