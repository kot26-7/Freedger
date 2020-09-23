RSpec.describe 'Devise::Sessions', type: :request do
  describe 'GET sessions#new' do
    before do
      get new_user_session_path
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the :index template' do
      expect(response).to render_template :new
    end

    it 'displayed on correct title' do
      expect(response.body).to include full_title('Login')
    end
  end

  describe 'GET sessions#create' do
    let(:user) { create(:user) }

    context 'parameters are valid' do
      it 'create request http is success' do
        post user_session_path, params: { user: { email: user.email, password: 'password' } }
        expect(response.status).to eq 302
      end

      it 'move to top page successfully' do
        post user_session_path, params: { user: { email: user.email, password: 'password' } }
        expect(response).to redirect_to root_path
      end
    end

    context 'parameters are invalid' do
      it 'returns http success' do
        post user_session_path, params: { user: { email: user.email, password: '' } }
        expect(response.status).to eq 200
      end

      it 'display on correct error' do
        post user_session_path, params: { user: { email: user.email, password: '' } }
        expect(response.body).to include 'Invalid Email or password.'
      end
    end
  end
end
