RSpec.describe 'Devise::Sessions', type: :system do
  describe 'GET /users/signin' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    it 'check if contents are displayed correctly on new_user_session' do
      within('.breadcrumb') do
        expect(page).to have_content 'Login'
      end
      within('#main-form') do
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Password'
        expect(page).to have_button 'Log in'
        expect(page).to have_field 'Email'
        expect(page).to have_field 'Password'
        expect(page).to have_unchecked_field 'remember_me'
      end
      within('#guest-login') do
        expect(page).to have_content 'or'
        expect(page).to have_button 'ゲストログイン(閲覧用)'
      end
    end

    it 'login succsessfully' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
      expect(current_path).to eq root_path
      expect(page).to have_content 'ログインしました。'
      visit current_path
      expect(page).not_to have_content 'ログインしました。'
    end

    it 'login failed' do
      fill_in 'Email', with: ''
      fill_in 'Password', with: user.password
      click_button 'Log in'
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Email もしくは パスワードが間違っています。'
      visit current_path
      expect(page).not_to have_content 'Email もしくは パスワードが間違っています。'
    end

    it 'ゲストログイン(閲覧用)を押してログインする', js: true do
      within('#guest-login') do
        page.accept_confirm do
          click_button 'ゲストログイン(閲覧用)'
        end
      end
      expect(page).to have_content 'ゲストユーザーとしてログインしました。'
      expect(current_path).to eq root_path
      visit current_path
      expect(page).not_to have_content 'ゲストユーザーとしてログインしました。'
    end
  end
end
