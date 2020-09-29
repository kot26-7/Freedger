require 'rails_helper'

RSpec.describe 'Container', type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit user_path(user)
  end

  describe 'GET container#new' do
    before do
      visit new_user_container_path(user)
    end

    it 'check if contents are displayed correctly on new_user_container_path' do
      within('.breadcrumb') do
        expect(page).to have_content 'コンテナ 作成'
      end
      within('#main-form') do
        expect(page).to have_content 'コンテナ名'
        expect(page).to have_content 'タイプ'
        expect(page).to have_content '説明文'
        expect(page).to have_content 'Fridge(冷蔵庫)'
        expect(page).to have_content 'Freezer(冷凍庫)'
        expect(page).to have_button 'コンテナ作成'
        expect(page).to have_field 'コンテナ名'
        expect(page).to have_field '説明文'
        expect(find_field('container_position_fridge')).to be_checked
        expect(find_field('container_position_freezer')).not_to be_checked
      end
    end

    it 'container create successfully' do
      within('#main-form') do
        fill_in 'コンテナ名', with: 'testhoge'
        fill_in '説明文', with: 'this is sample'
        click_button 'コンテナ作成'
      end
      expect(current_path).to eq user_container_path(user, 1)
      expect(page).to have_content 'コンテナが作成されました。'
      within('.breadcrumb') do
        expect(page).to have_content "Freedger - #{user.username} - testhoge"
      end
      within('.card') do
        expect(page).to have_content 'testhoge'
        expect(page).to have_content 'タイプ: Fridge'
        expect(page).to have_content '説明'
        expect(page).to have_content 'this is sample'
        expect(page).to have_button '飲食料品を登録する'
        expect(page).to have_css '.cog-link'
      end
      visit current_path
      expect(page).not_to have_content 'コンテナが作成されました。'
    end

    it 'container create failed' do
      within('#main-form') do
        fill_in 'コンテナ名', with: ''
        click_button 'コンテナ作成'
      end
      expect(page).to have_content 'can\'t be blank'
    end
  end

  describe 'GET container#index' do
    context 'when container exists' do
      let!(:containers) { create_list(:container, 2) }

      it 'check if contents are displayed correctly on user_containers' do
        visit user_containers_path(user)
        within('.breadcrumb') do
          expect(page).to have_content 'コンテナ 一覧'
        end
        expect(page).to have_link containers.first.name
        expect(page).to have_link containers.second.name
      end
    end

    context 'when container does not exists' do
      it 'check if contents are displayed correctly on user_containers' do
        visit user_containers_path(user)
        expect(page).to have_content 'コンテナが見つかりませんでした'
      end
    end
  end

  describe 'GET container#show' do
    let!(:container) { create(:container) }

    context 'when product not exist' do
      before do
        visit user_container_path(user, container)
      end

      it 'check if contents are displayed correctly on user_container_path' do
        within('.breadcrumb') do
          expect(page).to have_content "Freedger - #{user.username} - #{container.name}"
        end
        within('.card') do
          expect(page).to have_content container.name
          expect(page).to have_content "タイプ: #{container.position}"
          expect(page).not_to have_content '飲食料品:'
          expect(page).to have_content '説明'
          expect(page).to have_content container.description
          expect(page).to have_button '飲食料品を登録する'
          expect(page).to have_link container.name
          expect(page).to have_css '.cog-link'
        end
      end

      it 'cog icon を押してコンテナ編集ページにいく' do
        find('.cog-link').click
        expect(current_path).to eq edit_user_container_path(user, container)
      end

      it '飲食料品を登録する ボタンを押してproduct作成ページにいく' do
        click_button '飲食料品を登録する'
        expect(current_path).to eq new_user_container_product_path(user, container)
      end
    end

    context 'when products exist' do
      let!(:p_warning) { create(:product_warning) }
      let!(:p_expired) { create(:product_expired) }

      before do
        visit user_container_path(user, container)
      end

      it 'check if contents are displayed correctly on user_container' do
        within('.card') do
          expect(page).to have_content "飲食料品: #{container.products.size}"
        end
        expect(page).to have_content "#{container.name} 内の飲食料品"
        expect(page).to have_content p_warning.name
        expect(page).to have_content p_expired.name
        expect(page).to have_link p_warning.name
        expect(page).to have_link p_expired.name
      end

      it 'p_warning.name を押してproduct詳細ページにいく' do
        click_on p_warning.name
        expect(current_path).to eq user_container_product_path(user, container, p_warning)
      end
    end
  end

  describe 'GET container#edit' do
    let(:container) { create(:container) }

    before do
      visit edit_user_container_path(user, container)
    end

    it 'check if contents are displayed correctly on edit_user_container' do
      within('.breadcrumb') do
        expect(page).to have_content 'Freedger - コンテナ 編集'
      end
      within('#main-form') do
        expect(page).to have_content 'コンテナ名'
        expect(page).to have_content 'タイプ'
        expect(page).to have_content '説明文'
        expect(page).to have_content 'Fridge(冷蔵庫)'
        expect(page).to have_content 'Freezer(冷凍庫)'
        expect(page).to have_button '更新'
        expect(page).to have_field 'コンテナ名', with: container.name
        expect(page).to have_field '説明文', with: container.description
        expect(find_field('container_position_fridge')).to be_checked
        expect(find_field('container_position_freezer')).not_to be_checked
        expect(page).to have_link 'コンテナを削除'
      end
    end

    it 'container update successfully' do
      within('#main-form') do
        fill_in 'コンテナ名', with: 'testhoge'
        find("input[id='container_position_freezer']").set(true)
        fill_in '説明文', with: 'heres sample'
        click_button '更新'
      end
      expect(current_path).to eq user_container_path(user, container)
      expect(page).to have_content 'コンテナの情報が更新されました。'
      within('.breadcrumb') do
        expect(page).to have_content "Freedger - #{user.username} - testhoge"
      end
      within('.card') do
        expect(page).to have_content 'testhoge'
        expect(page).to have_content 'タイプ: Freezer'
        expect(page).to have_content 'heres sample'
      end
      visit current_path
      expect(page).not_to have_content 'コンテナの情報が更新されました。'
    end

    it 'container update failed' do
      within('#main-form') do
        fill_in 'コンテナ名', with: ''
        click_button '更新'
      end
      expect(page).to have_content 'can\'t be blank'
    end

    it 'Delete user successfully', js: true do
      page.accept_confirm do
        click_link 'コンテナを削除'
      end
      expect(page).to have_content 'コンテナが削除されました。'
      expect(current_path).to eq user_path(user)
      visit current_path
      expect(page).not_to have_content 'コンテナが削除されました。'
    end
  end
end
