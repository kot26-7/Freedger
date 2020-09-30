require 'rails_helper'

RSpec.describe 'Product', type: :system do
  let!(:user) { create(:user) }
  let!(:container) { create(:container) }

  before do
    sign_in user
    visit root_path
  end

  describe 'GET product#new' do
    before do
      visit new_user_container_product_path(user, container)
    end

    it 'check if contents are displayed correctly on new_user_container_product' do
      within('.breadcrumb') do
        expect(page).to have_content 'Freedger - 飲食料品 登録'
      end
      within('#main-form') do
        expect(page).to have_content '飲食料品名'
        expect(page).to have_content '数'
        expect(page).to have_content '説明文'
        expect(page).to have_content 'タグ'
        expect(page).to have_content '購入・調理日'
        expect(page).to have_content '消費期限'
        expect(page).to have_content 'イメージ'
        expect(page).to have_button '登録'
        expect(page).to have_field '飲食料品名'
        expect(page).to have_field '数'
        expect(page).to have_field '購入・調理日'
        expect(page).to have_field '消費期限'
        expect(page).to have_field 'タグ'
        expect(page).to have_field '説明文'
      end
    end

    it 'product create successfully' do
      within('#main-form') do
        fill_in '飲食料品名', with: 'testhoge'
        find('option[value=3]').select_option
        fill_in '購入・調理日', with: '2020-01-01'
        fill_in '消費期限', with: '2020-02-01'
        fill_in 'タグ', with: 'sample, test'
        fill_in '説明文', with: 'this is sample'
        click_button '登録'
      end
      expect(current_path).to eq user_container_product_path(user, container, 1)
      expect(page).to have_content '飲食料品の登録に成功しました。'
      within('#prd-shw-form') do
        expect(page).to have_link 'sample'
        expect(page).to have_link 'test'
        expect(page).to have_content '購入・調理日: 2020-01-01'
        expect(page).to have_content '消費期限: 2020-02-01'
        expect(page).to have_content '数: 3'
      end
      visit current_path
      expect(page).not_to have_content '飲食料品の登録に成功しました。'
      click_link 'sample'
      expect(current_path).to eq user_products_path(user)
      within('#prd-indx-form') do
        expect(page).to have_content 'タグ: sample'
        expect(page).to have_link 'testhoge'
      end
    end

    it 'product create failed with nil fields' do
      click_button '登録'
      expect(page).to have_content 'can\'t be blank'
      expect(page).not_to have_content 'is too long (maximum is 50 characters)'
      expect(page).not_to have_content 'is too long (maximum is 150 characters)'
    end

    it 'product create failed with word size validations' do
      fill_in '飲食料品名', with: 'a' * 51
      fill_in '購入・調理日', with: '2020-01-01'
      fill_in '消費期限', with: '2020-02-01'
      fill_in '説明文', with: 'a' * 151
      click_button '登録'
      expect(page).not_to have_content 'can\'t be blank'
      expect(page).to have_content 'is too long (maximum is 50 characters)'
      expect(page).to have_content 'is too long (maximum is 150 characters)'
    end
  end

  describe 'GET products#index' do
    context 'products present' do
      let!(:products) { create_list(:product, 2) }

      before do
        visit user_products_path(user)
      end

      it 'check if contents are displayed correctly on user_products' do
        within('.breadcrumb') do
          expect(page).to have_content 'Freedger - 飲食料品 一覧'
        end
        within('#prd-indx-form') do
          expect(page).to have_content "#{user.username} の飲食料品"
          expect(page).to have_link products.first.name
          expect(page).to have_link products.second.name
        end
      end

      it 'products.first.name を押してProduct詳細ページにいく' do
        click_link products.first.name
        expect(current_path).to eq user_container_product_path(user, container, products.first)
      end

      it 'searching successfully' do
        within('.breadcrumb') do
          expect(page).to have_css '.srch-icon'
        end
        within('#search-zone') do
          expect(page).to have_field 'Search'
          expect(page).to have_button 'button'
          fill_in 'Search', with: products.first.name
          click_button 'button'
        end
        expect(current_path).to eq user_products_path(user)
        within('#prd-indx-form') do
          expect(page).to have_content "キーワード: #{products.first.name}"
          expect(page).to have_link products.first.name
          expect(page).not_to have_link products.second.name
        end
      end

      it 'searching failed' do
        within('#search-zone') do
          fill_in 'Search', with: 'hogehoge'
          click_button 'button'
        end
        expect(current_path).to eq user_products_path(user)
        within('#prd-indx-form') do
          expect(page).to have_content '飲食料品が見つかりませんでした'
        end
      end
    end

    context 'products unpresent' do
      it 'check if contents are displayed correctly on user_products' do
        visit user_products_path(user)
        within('#prd-indx-form') do
          expect(page).to have_content '飲食料品が見つかりませんでした'
        end
      end
    end
  end

  describe 'GET products#show' do
    let(:product) { create(:product) }

    before do
      visit user_container_product_path(user, container, product)
    end

    it 'check if contents are displayed correctly on user_container_product' do
      within('.breadcrumb') do
        expect(page).to have_content "Freedger - #{user.username} - #{product.name}"
      end
      expect(page).to have_content "購入・調理日: #{product.product_created_at}"
      expect(page).to have_content "消費期限: #{product.product_expired_at}"
      expect(page).to have_content "数: #{product.number}"
      expect(page).to have_link "#{container.position}: #{container.name}"
      expect(page).to have_css '.edt-icon'
      expect(page).to have_css '.dlt-icon'
    end

    it 'Edit icon を押してproduct編集ページにいく' do
      find('.edt-icon').click
      expect(current_path).to eq edit_user_container_product_path(user, container, product)
    end

    it 'Delete product successfully', js: true do
      page.accept_confirm do
        find('.dlt-icon').click
      end
      expect(page).to have_content '飲食料品が削除されました。'
      expect(current_path).to eq user_path(user)
      visit current_path
      expect(page).not_to have_content '飲食料品が削除されました。'
    end
  end

  describe 'GET product#edit' do
    let(:product) { create(:product) }

    before do
      visit edit_user_container_product_path(user, container, product)
    end

    it 'check if contents are displayed correctly on edit_user_container_product' do
      within('.breadcrumb') do
        expect(page).to have_content '飲食料品 編集'
      end
      within('#main-form') do
        expect(page).to have_content '飲食料品名'
        expect(page).to have_content '数'
        expect(page).to have_content 'タグ'
        expect(page).to have_content '説明文'
        expect(page).to have_content '購入・調理日'
        expect(page).to have_content '消費期限'
        expect(page).to have_button '更新'
        expect(page).to have_field '飲食料品名', with: product.name
        expect(page).to have_field '数', with: product.number
        expect(page).to have_field '購入・調理日', with: product.product_created_at
        expect(page).to have_field '消費期限', with: product.product_expired_at
        expect(page).to have_field '説明文', with: product.description
        expect(page).to have_field 'タグ'
        expect(page).to have_link '飲食料品を削除'
      end
    end

    it 'product update successfully' do
      within('#main-form') do
        fill_in '飲食料品名', with: 'testhoge'
        find('option[value=4]').select_option
        fill_in '購入・調理日', with: '2020-01-01'
        fill_in '消費期限', with: '2020-02-01'
        fill_in '説明文', with: 'this is sample product'
        click_button '更新'
      end
      expect(current_path).to eq user_container_product_path(user, container, product)
      expect(page).to have_content '飲食料品の情報が更新されました。'
      within('.breadcrumb') do
        expect(page).to have_content "#{user.username} - testhoge"
      end
      expect(page).to have_content '購入・調理日: 2020-01-01'
      expect(page).to have_content '消費期限: 2020-02-01'
      expect(page).to have_content '数: 4'
      visit current_path
      expect(page).not_to have_content '飲食料品の情報が更新されました。'
    end

    it 'product update failed with nil fields' do
      within('#main-form') do
        fill_in '飲食料品名', with: ''
        fill_in '購入・調理日', with: ''
        fill_in '消費期限', with: ''
        click_button '更新'
      end
      expect(page).to have_content 'can\'t be blank'
      expect(page).not_to have_content 'is too long (maximum is 50 characters)'
      expect(page).not_to have_content 'is too long (maximum is 150 characters)'
    end

    it 'product create failed with word size validations' do
      fill_in '飲食料品名', with: 'a' * 51
      fill_in '説明文', with: 'a' * 151
      click_button '更新'
      expect(page).not_to have_content 'can\'t be blank'
      expect(page).to have_content 'is too long (maximum is 50 characters)'
      expect(page).to have_content 'is too long (maximum is 150 characters)'
    end

    it 'Delete product successfully', js: true do
      page.accept_confirm do
        click_link '飲食料品を削除'
      end
      expect(page).to have_content '飲食料品が削除されました。'
      expect(current_path).to eq user_path(user)
      visit current_path
      expect(page).not_to have_content '飲食料品が削除されました。'
    end
  end
end
