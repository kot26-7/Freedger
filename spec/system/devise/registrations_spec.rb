RSpec.describe 'Devise::Registrations', type: :system do
  describe 'GET /users/signup' do
    before do
      visit new_user_registration_path
    end

    it 'check if contents are displayed correctly on users/signup' do
      within('.breadcrumb') do
        expect(page).to have_content 'Signup'
      end
      within('.container') do
        expect(page).to have_content 'Username'
        expect(page).to have_content 'Email'
        expect(page).to have_content 'Password'
        expect(page).to have_content 'Password confirmation'
        expect(page).to have_button 'Sign up'
        expect(page).to have_field 'Username'
        expect(page).to have_field 'Email'
        expect(page).to have_field 'Password'
        expect(page).to have_field 'Password confirmation'
      end
    end

    it 'signup succsessfully' do
      fill_in 'Username', with: 'hogehoge'
      fill_in 'Email', with: 'foobar@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'
      expect(current_path).to eq user_path(1)
      expect(page).to have_content 'Welcome! You have signed up successfully.'
      within('.breadcrumb') do
        expect(page).to have_content 'hogehoge'
      end
      visit current_path
      expect(page).not_to have_content 'Welcome! You have signed up successfully.'
    end

    it 'signup failed' do
      fill_in 'Username', with: ''
      fill_in 'Email', with: 'foobar@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'
      expect(page).to have_content 'prohibited this user from being saved'
      expect(page).to have_content 'Username can\'t be blank'
      expect(page).to have_content 'Username is invalid'
      expect(page).not_to have_content 'Email is invalid'
      expect(page).not_to have_content 'Email can\'t be blank'
      expect(page).not_to have_content 'Password can\'t be blank'
    end
  end
end