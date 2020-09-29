require 'rails_helper'

RSpec.describe 'User', type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET user#show' do
    context 'only signin' do
      it 'check if contents are displayed correctly on user_path' do
        visit user_path(user)
        within('.breadcrumb') do
          expect(page).to have_content user.username
        end
        within('#user-profile-form') do
          expect(page).to have_content user.username
          expect(page).to have_content user.email
        end
      end
    end

    context 'when container exists' do
      let!(:container) { create(:container) }

      it 'container generated' do
        visit user_path(user)
        expect(page).to have_content 'コンテナ 情報'
        within('.card') do
          expect(page).to have_link container.name
          expect(page).to have_button '飲食料品を登録する'
        end
      end
    end
  end

  describe 'GET user#edit' do
    before do
      visit edit_user_path(user)
    end

    it 'check if contents are displayed correctly on edit_user' do
      within('.breadcrumb') do
        expect(page).to have_content 'Freedger - ユーザー編集'
      end
      within('#main-form') do
        expect(page).to have_content 'Username'
        expect(page).to have_content 'Email'
        expect(page).to have_button '更新'
        expect(page).to have_field 'Username', with: user.username
        expect(page).to have_field 'Email', with: user.email
        expect(page).to have_link 'パスワードを変更'
        expect(page).to have_link 'アカウントを削除'
      end
    end

    it 'パスワードを変更 を押してパスワード編集ページに飛ぶ' do
      click_link 'パスワードを変更'
      expect(current_path).to eq edit_user_registration_path
    end

    it 'update succsessfully' do
      fill_in 'Username', with: 'testhoge'
      click_button '更新'
      expect(current_path).to eq user_path(1)
      expect(page).to have_content 'ユーザー情報が更新されました。'
      within('.breadcrumb') do
        expect(page).to have_content 'testhoge'
      end
      visit current_path
      expect(page).not_to have_content 'ユーザー情報が更新されました。'
    end

    it 'update failed' do
      fill_in 'Username', with: ''
      click_button '更新'
      expect(page).to have_content 'can\'t be blank'
      expect(page).to have_content 'is invalid'
    end

    it 'Delete user successfully', js: true do
      page.accept_confirm do
        click_link 'アカウントを削除'
      end
      within '.sidenav' do
        expect(page).to have_link 'ホーム'
        expect(page).to have_link 'Login'
        expect(page).to have_link 'Signup'
      end
      expect(current_path).to eq root_path
      expect(page).to have_content 'ユーザーアカウントが削除されました。'
      visit current_path
      expect(page).not_to have_content 'ユーザーアカウントが削除されました。'
    end
  end

  describe 'GET /users/password_edit' do
    before do
      visit edit_user_registration_path
    end

    it 'check if contents are displayed correctly on edit_user_registration' do
      within('.breadcrumb') do
        expect(page).to have_content 'パスワード 変更'
      end
      within('#main-form') do
        expect(page).to have_content 'Password'
        expect(page).to have_content 'Password confirmation'
        expect(page).to have_content 'Current password'
        expect(page).to have_field 'Password'
        expect(page).to have_field 'Password confirmation'
        expect(page).to have_field 'Current password'
        expect(page).to have_button 'パスワードを更新'
        expect(page).to have_link '戻る'
      end
    end

    it 'password update succsessfully' do
      within('#main-form') do
        fill_in 'Password', with: 'hogehoge'
        fill_in 'Password confirmation', with: 'hogehoge'
        fill_in 'Current password', with: 'password'
        click_button 'パスワードを更新'
      end
      expect(current_path).to eq root_path
      expect(page).to have_content 'パスワードが更新されました。'
      visit current_path
      expect(page).not_to have_content 'パスワードが更新されました。'
    end
  end
end
