require 'rails_helper'

RSpec.describe 'Containers', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }

  context 'when sign_in' do
    before do
      sign_in user
      get user_path(user)
    end

    describe 'GET container#index' do
      let!(:containers) { create_list(:container, 2) }
      let!(:other_container) { create(:other_container) }

      before do
        get user_containers_path(user)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end

      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'assigns the requested container to @containers' do
        expect(assigns(:containers)).to eq containers
      end

      it 'displayed on correct title' do
        expect(response.body).to include full_title('All Containers')
      end

      it 'invalid access and redirect to user_path' do
        get user_containers_path(other_user)
        expect(response).to redirect_to user_path(user)
      end
    end

    describe 'GET container#show' do
      let(:container) { create(:container) }
      let(:other_container) { create(:other_container) }

      before do
        get user_container_path(user, container)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :show template' do
        expect(response).to render_template :show
      end

      it 'assigns the requested container to @container' do
        expect(assigns(:container)).to eq container
      end

      it 'displayed on correct title' do
        expect(response.body).to include full_title("#{user.username} - #{container.name}")
      end

      it 'invalid access and redirect to user_path' do
        get user_container_path(user, other_container)
        expect(response).to redirect_to user_path(user)
      end
    end

    describe 'GET container#new' do
      before do
        get new_user_container_path(user)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :new
      end

      it 'displayed on correct title' do
        expect(response.body).to include full_title('Container New')
      end
    end

    describe 'GET container#edit' do
      let(:container) { create(:container) }
      let(:other_container) { create(:other_container) }

      before do
        get edit_user_container_path(user, container)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :show template' do
        expect(response).to render_template :edit
      end

      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'assigns the requested container to @container' do
        expect(assigns(:container)).to eq container
      end

      it 'displayed on correct title' do
        expect(response.body).to include full_title('Edit Container')
      end

      it 'invalid access and redirect to user_path' do
        get edit_user_container_path(user, other_container)
        expect(response).to redirect_to user_path(user)
      end
    end

    describe 'container#create' do
      let(:container) { build(:container) }
      let(:container_params) do
        {
          user_id: user,
          container: attributes_for(:container),
        }
      end
      let(:invalid_container_params) do
        {
          user_id: user,
          container: attributes_for(:container, name: ''),
        }
      end

      before do
        get new_user_container_path(user)
      end

      context 'parameter is valid' do
        it 'create http has 302' do
          post user_containers_path, params: container_params
          expect(response.status).to eq 302
        end

        it 'create action has success' do
          expect do
            post user_containers_path, params: container_params
          end.to change(Container, :count).by 1
        end

        it 'redirects to user_container_path' do
          post user_containers_path, params: container_params
          expect(response).to redirect_to user_container_path(user, 1)
        end
      end

      context 'parameter is invalid' do
        before do
          post user_containers_path, params: invalid_container_params
        end

        it 'returns http success' do
          expect(response.status).to eq 200
        end
      end
    end

    describe 'container#update' do
      let(:container) { create(:container) }
      let(:valid_container_params) do
        {
          user_id: user,
          container: attributes_for(:container, name: 'sample container'),
        }
      end
      let(:invalid_container_params) do
        {
          user_id: user,
          container: attributes_for(:container, name: ''),
        }
      end

      before do
        get edit_user_container_path(user, container)
      end

      context 'parameter is valid' do
        it 'update http has 302' do
          patch user_container_path, params: valid_container_params
          expect(response.status).to eq 302
        end

        it 'parameter has changed successfully' do
          patch user_container_path, params: valid_container_params
          expect(container.reload.name).to eq 'sample container'
        end

        it 'redirects to user_container_path' do
          patch user_container_path, params: valid_container_params
          expect(response).to redirect_to user_container_path(user, container)
        end
      end

      context 'parameter is invalid' do
        it 'returns http success' do
          patch user_container_path, params: invalid_container_params
          expect(response.status).to eq 200
        end
      end
    end

    describe 'container#destroy' do
      let!(:container) { create(:container) }
      let!(:products) { create_list(:product, 2) }
      let!(:deadline_alert) { create(:deadline_alert) }

      before do
        get edit_user_container_path(user, container)
      end

      it 'destroy http is 302' do
        delete user_container_path, params: { user_id: user, container: container }
        expect(response.status).to eq 302
      end

      it 'redirects to user_path' do
        delete user_container_path, params: { user_id: user, container: container }
        expect(response).to redirect_to user_path(user)
      end

      it 'deletes a container' do
        expect do
          delete user_container_path, params: { user_id: user, container: container }
        end.to change(Container, :count).by(-1)
      end

      it 'deletes all products when container deleted' do
        expect do
          delete user_container_path, params: { user_id: user, container: container }
        end.to change(Product, :count).by(-2)
      end

      it 'deletes deadline_alert when container deleted' do
        expect do
          delete user_container_path, params: { user_id: user, container: container }
        end.to change(DeadlineAlert, :count).by(-1)
      end
    end
  end

  context 'when not sign_in' do
    before do
      get root_path
    end

    describe 'GET container#index' do
      let!(:containers) { create_list(:container, 2) }

      it 'going to login page' do
        get user_containers_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET container#show' do
      let(:container) { create(:container) }

      it 'going to login page' do
        get user_container_path(user, container)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET container#new' do
      it 'going to login page' do
        get new_user_container_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET container#edit' do
      let(:container) { create(:container) }

      it 'going to login page' do
        get edit_user_container_path(user, container)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'container#create' do
      let(:container) { build(:container) }
      let(:container_params) do
        { container: attributes_for(:container) }
      end

      it 'going to login page' do
        post user_containers_path(user), params: container_params
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'container#update' do
      let(:container) { create(:container) }
      let(:valid_container_params) do
        { container: attributes_for(:container, name: 'sample container') }
      end

      it 'going to login page' do
        patch user_container_path(id: container, user_id: user), params: valid_container_params
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'container#destroy' do
      let!(:container) { create(:container) }

      it 'going to login page' do
        delete user_container_path(user, container)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
