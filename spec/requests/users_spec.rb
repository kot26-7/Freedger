require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  context 'when sign_in' do
    before do
      sign_in user
      get user_path(user)
    end

    describe 'user#show' do
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :show template' do
        expect(response).to render_template :show
      end

      it 'displayed on correct title' do
        expect(response.body).to include full_title(user.username)
      end

      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'invalid access and redirect to user_path' do
        get user_path(other_user)
        expect(response).to redirect_to user_path(user)
      end
    end

    describe 'user#edit' do
      before do
        get edit_user_path(user)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :edit template' do
        expect(response).to render_template :edit
      end

      it 'displayed on correct title' do
        expect(response.body).to include full_title('ユーザー編集')
      end

      it 'invalid access and redirect to user_path' do
        get edit_user_path(other_user)
        expect(response).to redirect_to user_path(user)
      end
    end

    describe 'user#update' do
      context 'parameter is valid' do
        before do
          user_params = { username: 'hogehoge' }
          patch user_path, params: { id: user, user: user_params }
        end

        it 'update http has 302' do
          expect(response.status).to eq 302
        end

        it 'username has changed correctly' do
          expect(user.reload.username).to eq 'hogehoge'
        end

        it 'redirects to user_path' do
          expect(response).to redirect_to user_path(user)
        end
      end

      context 'parameter is invalid' do
        before do
          user_params = { username: '' }
          patch user_path, params: { id: user, user: user_params }
        end

        it 'returns http success' do
          expect(response.status).to eq 200
        end

        it 'username has not changed' do
          expect(user.reload.username).to eq 'test'
        end
      end

      it 'invalid access and redirect to user_path' do
        patch user_path, params: { id: other_user, user: { username: 'hogehoge' } }
        expect(response).to redirect_to user_path(user)
      end
    end

    describe 'user#destroy' do
      let!(:container) { create(:container) }
      let!(:products) { create_list(:product, 2) }
      let!(:deadline_alert) { create(:deadline_alert) }

      it 'deletes an user' do
        expect do
          delete user_path, params: { id: user }
        end.to change(User, :count).by(-1)
      end

      it 'redirects the page to root_path' do
        delete user_path, params: { id: user }
        expect(response).to redirect_to root_path
      end

      it 'deletes a container when user deleted' do
        expect do
          delete user_path, params: { id: user }
        end.to change(Container, :count).by(-1)
      end

      it 'deletes all products when user deleted' do
        expect do
          delete user_path, params: { id: user }
        end.to change(Product, :count).by(-2)
      end

      it 'deletes deadline_alert when user deleted' do
        expect do
          delete user_path, params: { id: user }
        end.to change(DeadlineAlert, :count).by(-1)
      end

      it 'invalid access and redirect to user_path' do
        delete user_path(other_user)
        expect(response).to redirect_to user_path(user)
      end
    end
  end

  context 'when not sign_in' do
    before do
      get root_path
    end

    describe 'user#show' do
      it 'going to login page' do
        get user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'user#edit' do
      it 'going to login page' do
        get edit_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'user#update' do
      it 'going to login page' do
        patch user_path(user), params: { user: { username: 'hogehoge' } }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'user#destroy' do
      it 'going to login page' do
        delete user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'user#guest_login' do
      it 'returns request http 302' do
        post guest_login_users_path
        expect(response.status).to eq 302
      end

      it 'redirect to top page successfully' do
        post guest_login_users_path
        expect(response).to redirect_to root_path
      end
    end
  end
end
