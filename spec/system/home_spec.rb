require 'rails_helper'

RSpec.describe 'Home', type: :system do
  describe 'GET home/index' do
    context 'if not signin' do
      before do
        visit root_path
      end

      it 'check if contents are displayed correctly on root' do
        expect(page).to have_title full_title('Home')
        within('.sidenav') do
          expect(page).to have_link 'ホーム'
          expect(page).to have_link 'Login'
          expect(page).to have_link 'Signup'
        end
        within('.breadcrumb') do
          expect(page).to have_content 'Freedger - Home'
          expect(page).not_to have_css '.srch-icon'
        end
        within('.jumbotron') do
          expect(page).to have_content 'Freedger へようこそ！'
          expect(page).to have_button 'Signup Here'
          expect(page).to have_button 'Login Here'
        end
        expect(page).not_to have_button '賞味期限をチェック'
      end

      it 'ホーム を押してホームページに飛ぶ' do
        within('.sidenav') do
          click_link 'ホーム'
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

    context 'if signin already' do
      let(:user) { create(:user) }

      before do
        sign_in user
        visit root_path
      end

      it 'check if contents are displayed correctly' do
        within '.sidenav' do
          expect(page).to have_link 'ホーム'
          expect(page).to have_link user.username
          expect(page).to have_link 'ユーザー 編集'
          expect(page).to have_link 'Logout'
          expect(page).to have_link 'コンテナ 作成'
          expect(page).not_to have_link 'Login'
          expect(page).not_to have_link 'Signup'
          expect(page).not_to have_link 'コンテナ 一覧'
          expect(page).not_to have_link '飲食料品 一覧'
          expect(page).not_to have_link 'アラート 一覧'
        end
        within('.breadcrumb') do
          expect(page).not_to have_css '.srch-icon'
        end
        within '.home-topic' do
          expect(page).to have_content 'コンテナに飲食料品が登録されていません。'
          expect(page).to have_content 'コンテナを作成もしくは飲食料品を登録してください。'
        end
      end

      it 'Username を押してユーザーページに飛ぶ' do
        click_link user.username
        expect(current_path).to eq user_path(user)
      end

      it 'ユーザー 編集 を押してユーザー編集ページに飛ぶ' do
        click_link 'ユーザー 編集'
        expect(current_path).to eq edit_user_path(user)
      end

      it 'コンテナ 作成 を押してコンテナ作成ページに飛ぶ' do
        click_link 'コンテナ 作成'
        expect(current_path).to eq new_user_container_path(user)
      end

      it 'Logout を押してログアウトする', js: true do
        page.accept_confirm do
          click_link 'Logout'
        end
        within '.sidenav' do
          expect(page).to have_link 'ホーム'
          expect(page).not_to have_link user.username
          expect(page).not_to have_link 'ユーザー 編集'
          expect(page).not_to have_link 'Logout'
          expect(page).not_to have_link 'コンテナ 一覧'
          expect(page).not_to have_link 'コンテナ 作成'
          expect(page).not_to have_link '飲食料品 一覧'
          expect(page).not_to have_link 'アラート 一覧'
          expect(page).to have_link 'Login'
          expect(page).to have_link 'Signup'
        end
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログアウトしました。'
        visit current_path
        expect(page).not_to have_content 'ログアウトしました。'
      end
    end

    context 'when signin and created container' do
      let!(:user) { create(:user) }
      let!(:container) { create(:container) }

      it 'コンテナ 一覧 link generated' do
        sign_in user
        visit root_path
        within('.breadcrumb') do
          expect(page).not_to have_css '.srch-icon'
        end
        within '.sidenav' do
          expect(page).to have_link 'コンテナ 一覧'
          click_link 'コンテナ 一覧'
        end
        expect(current_path).to eq user_containers_path(user)
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

      it '飲食料品 一覧 link generated' do
        within '.sidenav' do
          expect(page).to have_link '飲食料品 一覧'
          click_link '飲食料品 一覧'
        end
        within('.breadcrumb') do
          expect(page).to have_css '.srch-icon'
        end
        expect(current_path).to eq user_products_path(user)
      end

      it 'check if contents are displayed correctly' do
        within '.home-topic' do
          expect(page).to have_content '消費期限をチェックしましょう！'
          expect(page).to have_button '消費期限をチェック'
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

      it 'check if contents are displayed correctly' do
        within '.home-topic' do
          expect(page).to have_button '消費期限のアラートを更新'
        end
      end

      it 'アラート 一覧 link generated' do
        within '.sidenav' do
          expect(page).to have_link 'アラート 一覧'
          click_link 'アラート 一覧'
        end
        expect(current_path).to eq user_deadline_alerts_path(user)
      end
    end
  end

  describe 'GET home/about' do
    before do
      visit about_path
    end

    it 'check if contents are displayed correctly on about' do
      within('#about-topic') do
        expect(page).to have_content 'Step 1'
        expect(page).to have_content 'コンテナを作成'
        expect(page).to have_content 'Step 2'
        expect(page).to have_content '飲食料品の登録'
        expect(page).to have_content 'Step 3'
        expect(page).to have_content 'アラートを確認'
        expect(page).to have_css '.fa-archive'
        expect(page).to have_css '.fa-hamburger'
        expect(page).to have_css '.fa-exclamation-circle'
      end
      within('#about-btns') do
        expect(page).to have_button 'Signup Here'
        expect(page).to have_button 'Login Here'
      end
      within('#step1Modal') do
        expect(page).to have_content 'コンテナを作成'
        expect(page).to have_button 'Close'
        expect(page).to have_css("img[src*='step1_1']")
        expect(page).to have_css("img[src*='step1_2']")
      end
      within('#step2Modal') do
        expect(page).to have_content '飲食料品の登録'
        expect(page).to have_css("img[src*='step2_1']")
        expect(page).to have_css("img[src*='step2_2']")
        expect(page).to have_css("img[src*='step2_3']")
      end
      within('#step3Modal') do
        expect(page).to have_content 'アラートを確認'
        expect(page).to have_css("img[src*='step3_1']")
        expect(page).to have_css("img[src*='step3_2']")
      end
    end

    it 'Signup Here ボタンを押してユーザー登録ページに飛ぶ' do
      within('#about-btns') do
        click_button 'Signup Here'
      end
      expect(current_path).to eq new_user_registration_path
    end

    it 'Login Here ボタンを押してユーザーログインページに飛ぶ' do
      within('#about-btns') do
        click_button 'Login Here'
      end
      expect(current_path).to eq new_user_session_path
    end
  end
end
