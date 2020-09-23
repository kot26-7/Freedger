RSpec.describe 'Devise::Sessions', type: :system do
  describe 'GET /users/signin' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    it 'check if contents are displayed correctly on users/signin' do
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
    end

    it 'login succsessfully' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
      expect(current_path).to eq root_path
      expect(page).to have_content 'Login successfully.'
      visit current_path
      expect(page).not_to have_content 'Login successfully.'
    end

    it 'login failed' do
      fill_in 'Email', with: ''
      fill_in 'Password', with: user.password
      click_button 'Log in'
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'Invalid Email or password.'
      visit current_path
      expect(page).not_to have_content 'Invalid Email or password.'
    end
  end
end
