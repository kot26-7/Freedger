RSpec.describe 'Containers', type: :request do
  let(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }

  before do
    sign_in user
    get user_path(user)
  end

  describe 'GET container#index' do
    let!(:containers) { create_list(:container, 2) }

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
  end

  describe 'GET container#show' do
    let(:container) { create(:container) }
    let(:container2) { create(:container2) }

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

    it 'display on correct infomation' do
      expect(response.body).to include "Container type: #{container.position}"
      expect(response.body).to include "Description: #{container.description}"
    end

    it 'invalid access and redirect to the page user' do
      get user_container_path(user, container2)
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
    let(:container2) { create(:container2) }

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

    it 'invalid access and redirect to the page user' do
      get edit_user_container_path(user, container2)
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
      it 'create http has success' do
        post user_containers_path, params: container_params
        expect(response.status).to eq 302
      end

      it 'create action has success' do
        expect do
          post user_containers_path, params: container_params
        end.to change(Container, :count).by 1
      end

      it 'redirects the page to users/1/containers/1' do
        post user_containers_path, params: container_params
        expect(response).to redirect_to user_container_path(1, 1)
      end
    end

    context 'parameter is valid' do
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
      it 'update http has success' do
        patch user_container_path, params: valid_container_params
        expect(response.status).to eq 302
      end

      it 'parameter has changed successfully' do
        patch user_container_path, params: valid_container_params
        expect(container.reload.name).to eq 'sample container'
      end

      it 'redirects the page to users/1/containers/1' do
        patch user_container_path, params: valid_container_params
        expect(response).to redirect_to user_container_path(1, 1)
      end
    end

    context 'parameter is valid' do
      it 'returns http success' do
        patch user_container_path, params: invalid_container_params
        expect(response.status).to eq 200
      end
    end
  end

  describe 'container#destroy' do
    let!(:container) { create(:container) }

    before do
      get edit_user_container_path(user, container)
    end

    it 'destroy http has success' do
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
  end
end
