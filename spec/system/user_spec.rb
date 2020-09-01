RSpec.describe 'User', type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET user#show' do
    before do
      visit user_path(user)
    end

    it 'check if contents are displayed correctly on /users/:id' do
      within('.breadcrumb') do
        expect(page).to have_content user.username
      end
      expect(page).to have_link 'go to edit ur profile'
    end

    it 'edit を押してユーザー編集ページに飛ぶ' do
      click_link 'go to edit ur profile'
      expect(current_path).to eq edit_user_path(user)
    end
  end

  describe 'GET user#edit' do
    before do
      visit edit_user_path(user)
    end

    it 'check if contents are displayed correctly on /users/:id/edit' do
      within('.breadcrumb') do
        expect(page).to have_content 'Edit User'
      end
      within('.container') do
        expect(page).to have_content 'Username'
        expect(page).to have_content 'Email'
        expect(page).to have_button 'Update'
        expect(page).to have_field 'Username', with: user.username
        expect(page).to have_field 'Email', with: user.email
        expect(page).to have_link 'Change your password'
        expect(page).to have_link 'Delete account'
      end
    end

    it 'Change your password を押してパスワード編集ページに飛ぶ' do
      click_link 'Change your password'
      expect(current_path).to eq edit_user_registration_path
    end

    it 'update succsessfully' do
      fill_in 'Username', with: 'testhoge'
      click_button 'Update'
      expect(current_path).to eq user_path(1)
      expect(page).to have_content 'Update Your Profile successfully'
      within('.breadcrumb') do
        expect(page).to have_content 'testhoge'
      end
      visit current_path
      expect(page).not_to have_content 'Update Your Profile successfully'
    end

    it 'update failed' do
      fill_in 'Username', with: ''
      click_button 'Update'
      expect(page).to have_content 'prohibited this object from being saved: not successfully'
      expect(page).to have_content 'Username can\'t be blank'
      expect(page).to have_content 'Username is invalid'
      expect(page).not_to have_content 'Email is invalid'
      expect(page).not_to have_content 'Email can\'t be blank'
    end

    it 'Delete user successfully', js: true do
      page.accept_confirm do
        click_link 'Delete account'
      end
      expect(current_path).to eq root_path
      within '#navbarNav' do
        expect(page).to have_link 'Home'
        expect(page).not_to have_link 'User'
        expect(page).not_to have_link 'Logout'
        expect(page).to have_link 'Login'
        expect(page).to have_link 'Signup'
      end
      expect(page).to have_content 'User deleted'
      visit current_path
      expect(page).not_to have_content 'User deleted'
    end
  end

  describe 'GET /users/edit' do
    before do
      visit edit_user_registration_path
    end

    it 'check if contents are displayed correctly on users/edit' do
      within('.breadcrumb') do
        expect(page).to have_content 'Edit Password'
      end
      within('.container') do
        expect(page).to have_content 'Password'
        expect(page).to have_content 'Password confirmation'
        expect(page).to have_content 'Current password'
        expect(page).to have_field 'Password'
        expect(page).to have_field 'Password confirmation'
        expect(page).to have_field 'Current password'
        expect(page).to have_button 'Update'
        expect(page).to have_link 'Back'
      end
    end

    it 'password update succsessfully' do
      fill_in 'Password', with: 'hogehoge'
      fill_in 'Password confirmation', with: 'hogehoge'
      fill_in 'Current password', with: 'password'
      click_button 'Update'
      expect(current_path).to eq root_path
      expect(page).to have_content 'Your password has been updated successfully.'
      visit current_path
      expect(page).not_to have_content 'Your password has been updated successfully.'
    end
  end
end
