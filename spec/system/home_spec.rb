RSpec.describe 'Home', type: :system do
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
