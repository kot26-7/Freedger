require 'rails_helper'

RSpec.describe 'Home', type: :system do
  context 'if not signin' do
    describe 'GET home/index' do
      before do
        visit root_path
      end

      it 'check if contents are displayed correctly on home/index' do
        expect(page).to have_title full_title('Home')
        within('.sidenav') do
          expect(page).to have_link 'Home'
          expect(page).to have_link 'Login'
          expect(page).to have_link 'Signup'
        end
        within('.breadcrumb') do
          expect(page).to have_content 'Freedger - Home'
        end
        within('.jumbotron') do
          expect(page).to have_content 'Welcome to Freedger'
          expect(page).to have_button 'Signup Here'
          expect(page).to have_button 'Login Here'
        end
        expect(page).not_to have_button '賞味期限をチェック'
      end

      it 'Home を押してホームページに飛ぶ' do
        within('.sidenav') do
          click_link 'Home'
        end
        expect(current_path).to eq root_path
      end

      it 'Login を押してユーザーログインページに飛ぶ' do
        within('.sidenav') do
          click_link 'Login'
        end
        expect(current_path).to eq new_user_session_path
      end

      it 'Signup を押してユーザー登録ページに飛ぶ' do
        within('.sidenav') do
          click_link 'Signup'
        end
        expect(current_path).to eq new_user_registration_path
      end

      it 'Signup Here ボタンを押してユーザー登録ページに飛ぶ' do
        within('.jumbotron') do
          click_button 'Signup Here'
        end
        expect(current_path).to eq new_user_registration_path
      end

      it 'Login Here ボタンを押してユーザーログインページに飛ぶ' do
        within('.jumbotron') do
          click_button 'Login Here'
        end
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  context 'if signin already' do
    let(:user) { create(:user) }

    before do
      sign_in user
      visit root_path
    end

    describe 'GET home/index' do
      it 'check if contents are displayed correctly on header-navbar' do
        within '.sidenav' do
          expect(page).to have_link 'Home'
          expect(page).to have_link user.username
          expect(page).to have_link 'Edit User'
          expect(page).to have_link 'Logout'
          expect(page).to have_link 'Create Container'
          expect(page).not_to have_link 'Login'
          expect(page).not_to have_link 'Signup'
          expect(page).not_to have_link 'All Containers'
          expect(page).not_to have_link 'All Products'
          expect(page).not_to have_link 'Alerts'
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

      it 'Create Container を押してコンテナ作成ページに飛ぶ' do
        click_link 'Create Container'
        expect(current_path).to eq new_user_container_path(user)
      end

      it 'Logout を押してログアウトする' do
        click_link 'Logout'
        expect(current_path).to eq root_path
        within '.sidenav' do
          expect(page).to have_link 'Home'
          expect(page).not_to have_link user.username
          expect(page).not_to have_link 'Edit User'
          expect(page).not_to have_link 'Logout'
          expect(page).not_to have_link 'All Containers'
          expect(page).not_to have_link 'Create Container'
          expect(page).not_to have_link 'All Products'
          expect(page).not_to have_link 'Alerts'
          expect(page).to have_link 'Login'
          expect(page).to have_link 'Signup'
        end
        expect(page).to have_content 'Signed out successfully.'
        visit current_path
        expect(page).not_to have_content 'Signed out successfully.'
      end
    end
  end

  context 'when signin and created container' do
    let!(:user) { create(:user) }
    let!(:container) { create(:container) }

    before do
      sign_in user
      visit root_path
    end

    describe 'GET home/index' do
      it 'All Containers link generated' do
        within '.sidenav' do
          expect(page).to have_link 'All Containers'
          click_link 'All Containers'
        end
        expect(current_path).to eq user_containers_path(user)
      end
    end
  end

  context 'when signin and created product' do
    let!(:user) { create(:user) }
    let!(:container) { create(:container) }
    let!(:product) { create(:product) }

    before do
      sign_in user
      visit root_path
    end

    describe 'GET home/index' do
      it 'All Products link generated' do
        within '.sidenav' do
          expect(page).to have_link 'All Products'
          click_link 'All Products'
        end
        expect(current_path).to eq user_products_path(user)
      end
    end
  end

  context 'when signin and created deadline_alerts' do
    let!(:user) { create(:user) }
    let!(:container) { create(:container) }
    let!(:product) { create(:product) }
    let!(:deadline_alert) { create(:deadline_alert) }

    before do
      sign_in user
      visit root_path
    end

    describe 'GET home/index' do
      it 'Alerts link generated' do
        within '.sidenav' do
          expect(page).to have_link 'Alerts'
          click_link 'Alerts'
        end
        expect(current_path).to eq user_deadline_alerts_path(user)
      end
    end
  end
end
