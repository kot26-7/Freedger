require 'rails_helper'

RSpec.describe 'DeadlineAlert', type: :system do
  let!(:user) { create(:user) }
  let!(:container) { create(:container) }
  let!(:p_warning) { create(:product_warning) }
  let!(:p_expired) { create(:product_expired) }
  let!(:p_recom) { create(:product_recommend) }

  before do
    sign_in user
    visit root_path
  end

  describe 'deadline_alerts#create & index & destroy' do
    around do |e|
      travel_to('2020-4-10 10:00') { e.run }
    end

    it 'deadline_alerts create successfully' do
      expect(current_path).to eq root_path(user)
      expect(page).to have_button '賞味期限をチェック'
      click_button '賞味期限をチェック'
      expect(current_path).to eq user_deadline_alerts_path(user)
      expect(page).to have_content 'Searched Successfully'
      within('.breadcrumb') do
        expect(page).to have_content 'Results'
      end
      within('.deadline_expired') do
        expect(page).to have_content 'Expired'
        expect(page).to have_content "#{p_expired.container.position} - #{p_expired.container.name}"
        expect(page).to have_content p_expired.name
        expect(page).to have_content "期限 - #{p_expired.product_expired_at}"
        expect(page).to have_link 'Delete'
      end
      within('.deadline_warning') do
        expect(page).to have_content 'Warning'
        expect(page).to have_content "#{p_warning.container.position} - #{p_warning.container.name}"
        expect(page).to have_content p_warning.name
        expect(page).to have_content "期限 - #{p_warning.product_expired_at}"
        expect(page).to have_link 'Delete'
      end
      within('.deadline_recommend') do
        expect(page).to have_content 'Recommend'
        expect(page).to have_content "#{p_recom.container.position} - #{p_recom.container.name}"
        expect(page).to have_content p_recom.name
        expect(page).to have_content "期限 - #{p_recom.product_expired_at}"
        expect(page).to have_link 'Delete'
      end
      visit current_path
      expect(page).not_to have_content 'Searched Successfully'
    end

    it 'deadline_alert delete successfully' do
      click_button '賞味期限をチェック'
      expect(current_path).to eq user_deadline_alerts_path(user)
      within('.deadline_expired') do
        expect(page).to have_link 'Delete'
        click_link 'Delete'
      end
      expect(page).to have_content 'Deleted Successfully'
      expect(page).not_to have_content 'Expired'
      within('.deadline_warning') do
        expect(page).to have_content 'Warning'
      end
      within('.deadline_recommend') do
        expect(page).to have_content 'Recommend'
      end
      visit current_path
      expect(page).not_to have_content 'Deleted Successfully'
    end
  end
end
