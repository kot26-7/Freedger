RSpec.describe 'Devise::Registrations', type: :request do
  let(:user) { build(:user) }
  let(:user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, username: '') }

  describe 'GET registrations#new' do
    before do
      get new_user_registration_path
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the :index template' do
      expect(response).to render_template :new
    end

    it 'displayed on correct title' do
      expect(response.body).to include full_title('Signup')
    end
  end

  describe 'GET registrations#create' do
    context 'parameters are valid' do
      it 'create request http is 302' do
        post user_registration_path, params: { user: user_params }
        expect(response.status).to eq 302
      end

      it 'create action has success' do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by 1
      end

      it 'redirect to top page successfully' do
        post user_registration_path, params: { user: user_params }
        expect(response).to redirect_to root_path
      end
    end

    context 'parameters are invalid' do
      it 'returns http success' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.status).to eq 200
      end

      it 'create has failed' do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.not_to change(User, :count)
      end
    end
  end
end
