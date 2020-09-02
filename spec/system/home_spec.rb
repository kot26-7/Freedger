RSpec.describe 'Home', type: :system do
  context 'if not signin' do
    describe 'GET /index' do
      before do
        visit root_path
      end

      it 'check if contents are displayed correctly on home/index' do
        expect(page).to have_title full_title('Home')
        within('header') do
          expect(page).to have_link 'Freedger'
        end
        within '#navbarNav' do
          expect(page).to have_link 'Home'
          expect(page).to have_link 'Login'
          expect(page).to have_link 'Signup'
        end
        within('.breadcrumb') do
          expect(page).to have_content 'Home'
        end
      end

      it 'My_app を押してホームページに飛ぶ' do
        within('header') do
          click_link 'Freedger'
        end
        expect(current_path).to eq root_path
      end

      it 'Home を押してホームページに飛ぶ' do
        within('#navbarNav') do
          click_link 'Home'
        end
        expect(current_path).to eq root_path
      end

      it 'Login を押してユーザーログインページに飛ぶ' do
        within('#navbarNav') do
          click_link 'Login'
        end
        expect(current_path).to eq new_user_session_path
      end

      it 'Signup を押してユーザー登録ページに飛ぶ' do
        within('#navbarNav') do
          click_link 'Signup'
        end
        expect(current_path).to eq new_user_registration_path
      end
    end
  end

  context 'if signin already' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit root_path
    end

    describe 'GET page with sign_in user' do
      it 'check if contents are displayed correctly on header-navbar' do
        within '#navbarNav' do
          expect(page).to have_link 'Home'
          expect(page).to have_link 'User'
          expect(page).to have_link user.username
          expect(page).to have_link 'Edit User'
          expect(page).to have_link 'Logout'
          expect(page).to have_link 'Containers'
          expect(page).to have_link 'All Containers'
          expect(page).to have_link 'Create Container'
          expect(page).to have_link 'Products'
          expect(page).not_to have_link 'Login'
          expect(page).not_to have_link 'Signup'
        end
      end

      it 'Username を押してユーザーページに飛ぶ' do
        click_link user.username
        expect(current_path).to eq user_path(user)
      end

      it 'Edit User を押してユーザー編集ページに飛ぶ' do
        click_link 'Edit User'
        expect(current_path).to eq edit_user_path(user)
      end

      it 'All Containers を押してコンテナ一覧ページに飛ぶ' do
        click_link 'All Containers'
        expect(current_path).to eq user_containers_path(user)
      end

      it 'Create Container を押してコンテナ作成ページに飛ぶ' do
        click_link 'Create Container'
        expect(current_path).to eq new_user_container_path(user)
      end

      it 'Products を押してProducts覧ページに飛ぶ' do
        click_link 'Products'
        expect(current_path).to eq user_products_path(user)
      end

      it 'Logout を押してログアウトする' do
        click_link 'Logout'
        expect(current_path).to eq root_path
        within '#navbarNav' do
          expect(page).to have_link 'Home'
          expect(page).not_to have_link 'User'
          expect(page).not_to have_link user.username
          expect(page).not_to have_link 'Edit User'
          expect(page).not_to have_link 'Logout'
          expect(page).not_to have_link 'Containers'
          expect(page).not_to have_link 'All Containers'
          expect(page).not_to have_link 'Create Container'
          expect(page).not_to have_link 'Products'
          expect(page).to have_link 'Login'
          expect(page).to have_link 'Signup'
        end
        expect(page).to have_content 'Signed out successfully.'
        visit current_path
        expect(page).not_to have_content 'Signed out successfully.'
      end
    end
  end
end
