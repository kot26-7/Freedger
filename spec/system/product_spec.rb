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

    it 'check if contents are displayed correctly on users/:user_id/products/new' do
      within('.breadcrumb') do
        expect(page).to have_content 'Freedger - Create Product'
      end
      within('#main-form') do
        expect(page).to have_content 'Name'
        expect(page).to have_content 'Number'
        expect(page).to have_content 'Description'
        expect(page).to have_content 'Product created at'
        expect(page).to have_content 'Product expired at'
        expect(page).to have_button 'Create'
        expect(page).to have_field 'Name'
        expect(page).to have_field 'Number'
        expect(page).to have_field 'Product created at'
        expect(page).to have_field 'Product expired at'
        expect(page).to have_field 'Description'
      end
    end

    it 'product create successfully' do
      within('#main-form') do
        fill_in 'Name', with: 'testhoge'
        find('option[value=3]').select_option
        fill_in 'Product created at', with: '2020-01-01'
        fill_in 'Product expired at', with: '2020-02-01'
        fill_in 'Description', with: 'this is sample'
        click_button 'Create'
      end
      expect(current_path).to eq user_container_product_path(user, container, 1)
      expect(page).to have_content 'Product created Successfully'
      within('#prd-shw-form') do
        expect(page).to have_content 'Created_at: 2020-01-01'
        expect(page).to have_content 'Expiration_date: 2020-02-01'
        expect(page).to have_content 'Quantity: 3'
      end
      visit current_path
      expect(page).not_to have_content 'Product created Successfully'
    end

    it 'product create failed with nil fields' do
      click_button 'Create'
      expect(page).to have_content 'can\'t be blank'
      expect(page).not_to have_content 'is too long (maximum is 50 characters)'
      expect(page).not_to have_content 'is too long (maximum is 150 characters)'
    end

    it 'product create failed with word size validations' do
      fill_in 'Name', with: 'a' * 51
      fill_in 'Product created at', with: '2020-01-01'
      fill_in 'Product expired at', with: '2020-02-01'
      fill_in 'Description', with: 'a' * 151
      click_button 'Create'
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

      it 'check if contents are displayed correctly on users/:user_id/containers' do
        within('.breadcrumb') do
          expect(page).to have_content 'Freedger - All Products'
        end
        within('#prd-indx-form') do
          expect(page).to have_content "#{user.username} 's Products"
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
          expect(page).to have_content 'No products found'
        end
      end
    end

    context 'products unpresent' do
      before do
        visit user_products_path(user)
      end

      it 'check if contents are displayed correctly on users/:user_id/containers' do
        within('#prd-indx-form') do
          expect(page).to have_content 'No products found'
        end
      end
    end
  end

  describe 'GET products#show' do
    let(:product) { create(:product) }

    before do
      visit user_container_product_path(user, container, product)
    end

    it 'check if contents are displayed correctly on users/:user_id/containers/:id' do
      within('.breadcrumb') do
        expect(page).to have_content "Freedger - #{user.username} - #{product.name}"
      end
      expect(page).to have_content "Created_at: #{product.product_created_at}"
      expect(page).to have_content "Expiration_date: #{product.product_expired_at}"
      expect(page).to have_content "Quantity: #{product.number}"
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
      expect(page).to have_content 'Deleted Product Successfully'
      expect(current_path).to eq user_path(user)
      visit current_path
      expect(page).not_to have_content 'Deleted Product Successfully'
    end
  end

  describe 'GET product#edit' do
    let(:product) { create(:product) }

    before do
      visit edit_user_container_product_path(user, container, product)
    end

    it 'check if contents are displayed correctly on users/:user_id/products/:id/edit' do
      within('.breadcrumb') do
        expect(page).to have_content 'Edit Product'
      end
      within('#main-form') do
        expect(page).to have_content 'Name'
        expect(page).to have_content 'Number'
        expect(page).to have_content 'Description'
        expect(page).to have_content 'Product created at'
        expect(page).to have_content 'Product expired at'
        expect(page).to have_button 'Update'
        expect(page).to have_field 'Name', with: product.name
        expect(page).to have_field 'Number', with: product.number
        expect(page).to have_field 'Product created at', with: product.product_created_at
        expect(page).to have_field 'Product expired at', with: product.product_expired_at
        expect(page).to have_field 'Description', with: product.description
        expect(page).to have_link 'Delete product'
      end
    end

    it 'product update successfully' do
      within('#main-form') do
        fill_in 'Name', with: 'testhoge'
        find('option[value=4]').select_option
        fill_in 'Product created at', with: '2020-01-01'
        fill_in 'Product expired at', with: '2020-02-01'
        fill_in 'Description', with: 'this is sample product'
        click_button 'Update'
      end
      expect(current_path).to eq user_container_product_path(user, container, product)
      expect(page).to have_content 'Update Successfully'
      within('.breadcrumb') do
        expect(page).to have_content "#{user.username} - testhoge"
      end
      expect(page).to have_content 'Created_at: 2020-01-01'
      expect(page).to have_content 'Expiration_date: 2020-02-01'
      expect(page).to have_content 'Quantity: 4'
      visit current_path
      expect(page).not_to have_content 'Update Successfully'
    end

    it 'product update failed with nil fields' do
      within('#main-form') do
        fill_in 'Name', with: ''
        fill_in 'Product created at', with: ''
        fill_in 'Product expired at', with: ''
        click_button 'Update'
      end
      expect(page).to have_content 'can\'t be blank'
      expect(page).not_to have_content 'is too long (maximum is 50 characters)'
      expect(page).not_to have_content 'is too long (maximum is 150 characters)'
    end

    it 'product create failed with word size validations' do
      fill_in 'Name', with: 'a' * 51
      fill_in 'Description', with: 'a' * 151
      click_button 'Update'
      expect(page).not_to have_content 'can\'t be blank'
      expect(page).to have_content 'is too long (maximum is 50 characters)'
      expect(page).to have_content 'is too long (maximum is 150 characters)'
    end

    it 'Delete product successfully', js: true do
      page.accept_confirm do
        click_link 'Delete product'
      end
      expect(page).to have_content 'Deleted Product Successfully'
      expect(current_path).to eq user_path(user)
      visit current_path
      expect(page).not_to have_content 'Deleted Product Successfully'
    end
  end
end
