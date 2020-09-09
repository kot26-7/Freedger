RSpec.describe 'Products', type: :request do
  let!(:user) { create(:user) }
  let!(:container) { create(:container) }

  before do
    sign_in user
    get root_path
  end

  describe 'GET product#index' do
    let!(:products) { create_list(:product, 2) }

    before do
      get user_products_path(user)
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

    it 'assigns the requested container to @products' do
      expect(assigns(:products)).to eq products
    end

    it 'displayed on correct title' do
      expect(response.body).to include full_title('All Products')
    end
  end

  describe 'GET product#show' do
    let!(:product) { create(:product) }

    before do
      get user_container_product_path(user, container, product)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the :show template' do
      expect(response).to render_template :show
    end

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'assigns the requested container to @container' do
      expect(assigns(:container)).to eq container
    end

    it 'assigns the requested user to @product' do
      expect(assigns(:product)).to eq product
    end

    it 'displayed on correct title' do
      expect(response.body).to include full_title("#{user.username} - #{product.name}")
    end
  end

  describe 'GET product#new' do
    before do
      get new_user_container_product_path(user, container)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the :new template' do
      expect(response).to render_template :new
    end

    it 'displayed on correct title' do
      expect(response.body).to include full_title('Create Product')
    end
  end

  describe 'GET product#edit' do
    let!(:product) { create(:product) }

    before do
      get edit_user_container_product_path(user, container, product)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders the :edit template' do
      expect(response).to render_template :edit
    end

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'assigns the requested container to @container' do
      expect(assigns(:container)).to eq container
    end

    it 'assigns the requested user to @product' do
      expect(assigns(:product)).to eq product
    end

    it 'displayed on correct title' do
      expect(response.body).to include full_title('Edit Product')
    end
  end

  describe 'product#create' do
    let(:product) { build(:product) }
    let(:valid_product_params) do
      {
        user_id: user,
        container_id: container,
        product: attributes_for(:product),
      }
    end
    let(:invalid_product_params) do
      {
        user_id: user,
        container_id: container,
        product: attributes_for(:product, name: ''),
      }
    end

    before do
      get new_user_container_product_path(user, container)
    end

    context 'parameter is valid' do
      it 'create http has success' do
        post user_container_products_path, params: valid_product_params
        expect(response.status).to eq 302
      end

      it 'create action has success' do
        expect do
          post user_container_products_path, params: valid_product_params
        end.to change(Product, :count).by 1
      end

      it 'redirects the page to users/1/containers/1/products/1' do
        post user_container_products_path, params: valid_product_params
        expect(response).to redirect_to user_container_product_path(1, 1, 1)
      end
    end

    context 'parameter is valid' do
      before do
        post user_container_products_path, params: invalid_product_params
      end

      it 'returns http success' do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'product#update' do
    let(:product) { create(:product) }
    let(:valid_product_params) do
      {
        user_id: user,
        container_id: container,
        product: attributes_for(:product, name: 'sample product'),
      }
    end
    let(:invalid_product_params) do
      {
        user_id: user,
        container_id: container,
        product: attributes_for(:product, name: ''),
      }
    end

    before do
      get edit_user_container_product_path(user, container, product)
    end

    context 'parameter is valid' do
      it 'update http has success' do
        patch user_container_product_path, params: valid_product_params
        expect(response.status).to eq 302
      end

      it 'parameter has changed successfully' do
        patch user_container_product_path, params: valid_product_params
        expect(product.reload.name).to eq 'sample product'
      end

      it 'redirects the page to users/1/containers/1/products/1' do
        patch user_container_product_path, params: valid_product_params
        expect(response).to redirect_to user_container_product_path(1, 1, 1)
      end
    end

    context 'parameter is valid' do
      it 'returns http success' do
        patch user_container_product_path, params: invalid_product_params
        expect(response.status).to eq 200
      end
    end
  end

  describe 'product#destroy' do
    let!(:product) { create(:product) }
    let(:product_params) { { user_id: user, container_id: container, product: product } }
    let!(:deadline_alert) { create(:deadline_alert) }

    before do
      get edit_user_container_product_path(user, container, product)
    end

    it 'destroy http has success' do
      delete user_container_product_path, params: product_params
      expect(response.status).to eq 302
    end

    it 'redirects to user_path' do
      delete user_container_product_path, params: product_params
      expect(response).to redirect_to user_path(user)
    end

    it 'deletes an user' do
      expect do
        delete user_container_product_path, params: product_params
      end.to change(Product, :count).by(-1)
    end

    it 'deletes deadline_alert when product deleted' do
      expect do
        delete user_container_product_path, params: product_params
      end.to change(DeadlineAlert, :count).by(-1)
    end
  end
end
