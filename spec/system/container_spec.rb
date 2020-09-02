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

    it 'container create successfully' do
      fill_in 'Name', with: 'testhoge'
      fill_in 'Description', with: 'this is sample'
      click_button 'Create'
      expect(current_path).to eq user_container_path(user, 1)
      expect(page).to have_content 'Container created Successfully'
      within('.breadcrumb') do
        expect(page).to have_content "#{user.username} - testhoge"
      end
      expect(page).to have_content 'Container type: Fridge'
      expect(page).to have_content 'Description: this is sample'
      visit current_path
      expect(page).not_to have_content 'Container created Successfully'
    end

    it 'container create failed' do
      fill_in 'Name', with: ''
      click_button 'Create'
      expect(page).to have_content 'Name can\'t be blank'
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
    let(:container) { create(:container) }

    before do
      visit user_container_path(user, container)
    end

    it 'check if contents are displayed correctly on users/:user_id/containers/:id' do
      within('.breadcrumb') do
        expect(page).to have_content "#{user.username} - #{container.name}"
      end
      expect(page).to have_content "Container type: #{container.position}"
      expect(page).to have_content "Description: #{container.description}"
      expect(page).to have_link 'go to edit container'
    end

    it 'go to edit container を押してコンテナ編集ページにいく' do
      click_link 'go to edit container'
      expect(current_path).to eq edit_user_container_path(user, container)
    end
  end

  describe 'GET container#edit' do
    let(:container) { create(:container) }

    before do
      visit edit_user_container_path(user, container)
    end

    it 'check if contents are displayed correctly on users/:user_id/containers/:id/edit' do
      within('.breadcrumb') do
        expect(page).to have_content 'Edit Container'
      end
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

    it 'container update successfully' do
      fill_in 'Name', with: 'testhoge'
      find("input[id='container_position_freezer']").set(true)
      fill_in 'Description', with: 'heres sample'
      click_button 'Update'
      expect(current_path).to eq user_container_path(user, container)
      expect(page).to have_content 'Update Successfully'
      within('.breadcrumb') do
        expect(page).to have_content "#{user.username} - testhoge"
      end
      expect(page).to have_content 'Container type: Freezer'
      expect(page).to have_content 'Description: heres sample'
      visit current_path
      expect(page).not_to have_content 'Update Successfully'
    end

    it 'container update failed' do
      fill_in 'Name', with: ''
      click_button 'Update'
      expect(page).to have_content 'Name can\'t be blank'
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
