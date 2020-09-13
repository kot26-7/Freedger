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

    it 'check if contents are displayed correctly on users/:user_id/containers' do
      within('.breadcrumb') do
        expect(page).to have_content 'Container New'
      end
      within('#main-form') do
        expect(page).to have_content 'Name'
        expect(page).to have_content 'Container type'
        expect(page).to have_content 'Description'
        expect(page).to have_content 'Fridge'
        expect(page).to have_content 'Freezer'
        expect(page).to have_button 'Create'
        expect(page).to have_field 'Name'
        expect(page).to have_field 'Description'
        expect(find_field('container_position_fridge')).to be_checked
        expect(find_field('container_position_freezer')).not_to be_checked
      end
    end

    it 'container create successfully' do
      within('#main-form') do
        fill_in 'Name', with: 'testhoge'
        fill_in 'Description', with: 'this is sample'
        click_button 'Create'
      end
      expect(current_path).to eq user_container_path(user, 1)
      expect(page).to have_content 'Container created Successfully'
      within('.breadcrumb') do
        expect(page).to have_content "Freedger - #{user.username} - testhoge"
      end
      within('.card') do
        expect(page).to have_content 'testhoge'
        expect(page).to have_content 'Type: Fridge'
        expect(page).to have_content 'Description'
        expect(page).to have_content 'this is sample'
        expect(page).to have_button 'Create product'
        expect(page).to have_css '.cog-link'
      end
      visit current_path
      expect(page).not_to have_content 'Container created Successfully'
    end

    it 'container create failed' do
      within('#main-form') do
        fill_in 'Name', with: ''
        click_button 'Create'
      end
      expect(page).to have_content 'can\'t be blank'
    end
  end

  describe 'GET container#index' do
    let!(:containers) { create_list(:container, 2) }

    before do
      visit user_containers_path(user)
    end

    it 'check if contents are displayed correctly on users/:user_id/containers' do
      within('.breadcrumb') do
        expect(page).to have_content 'All Containers'
      end
      expect(page).to have_link containers.first.name
      expect(page).to have_link containers.second.name
    end
  end

  describe 'GET container#show' do
    let!(:container) { create(:container) }

    context 'when product not exist' do
      before do
        visit user_container_path(user, container)
      end

      it 'check if contents are displayed correctly on users/:user_id/containers/:id' do
        within('.breadcrumb') do
          expect(page).to have_content "Freedger - #{user.username} - #{container.name}"
        end
        within('.card') do
          expect(page).to have_content container.name
          expect(page).to have_content "Type: #{container.position}"
          expect(page).not_to have_content 'Products:'
          expect(page).to have_content 'Description'
          expect(page).to have_content container.description
          expect(page).to have_button 'Create product'
          expect(page).to have_link container.name
          expect(page).to have_css '.cog-link'
        end
      end

      it 'cog icon を押してコンテナ編集ページにいく' do
        find('.cog-link').click
        expect(current_path).to eq edit_user_container_path(user, container)
      end

      it 'Create product ボタンを押してproduct作成ページにいく' do
        click_button 'Create product'
        expect(current_path).to eq new_user_container_product_path(user, container)
      end
    end

    context 'when products exist' do
      let!(:p_warning) { create(:product_warning) }
      let!(:p_expired) { create(:product_expired) }

      before do
        visit user_container_path(user, container)
      end

      it 'check if contents are displayed correctly on users/:user_id/containers/:id' do
        within('.card') do
          expect(page).to have_content "Products: #{container.products.size}"
        end
        expect(page).to have_content "Products in #{container.name}"
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

    it 'check if contents are displayed correctly on users/:user_id/containers/:id/edit' do
      within('.breadcrumb') do
        expect(page).to have_content 'Freedger - Edit Container'
      end
      within('#main-form') do
        expect(page).to have_content 'Name'
        expect(page).to have_content 'Container type'
        expect(page).to have_content 'Description'
        expect(page).to have_content 'Fridge'
        expect(page).to have_content 'Freezer'
        expect(page).to have_button 'Update'
        expect(page).to have_field 'Name', with: container.name
        expect(page).to have_field 'Description', with: container.description
        expect(find_field('container_position_fridge')).to be_checked
        expect(find_field('container_position_freezer')).not_to be_checked
        expect(page).to have_link 'Delete container'
      end
    end

    it 'container update successfully' do
      within('#main-form') do
        fill_in 'Name', with: 'testhoge'
        find("input[id='container_position_freezer']").set(true)
        fill_in 'Description', with: 'heres sample'
        click_button 'Update'
      end
      expect(current_path).to eq user_container_path(user, container)
      expect(page).to have_content 'Update Successfully'
      within('.breadcrumb') do
        expect(page).to have_content "Freedger - #{user.username} - testhoge"
      end
      within('.card') do
        expect(page).to have_content 'testhoge'
        expect(page).to have_content 'Type: Freezer'
        expect(page).to have_content 'heres sample'
      end
      visit current_path
      expect(page).not_to have_content 'Update Successfully'
    end

    it 'container update failed' do
      within('#main-form') do
        fill_in 'Name', with: ''
        click_button 'Update'
      end
      expect(page).to have_content 'can\'t be blank'
    end

    it 'Delete user successfully', js: true do
      page.accept_confirm do
        click_link 'Delete container'
      end
      expect(page).to have_content 'Deleted Container Successfully'
      expect(current_path).to eq user_path(user)
      visit current_path
      expect(page).not_to have_content 'Deleted Container Successfully'
    end
  end
end
