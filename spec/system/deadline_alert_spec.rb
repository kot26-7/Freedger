require 'rails_helper'

RSpec.describe 'DeadlineAlert', type: :system do
  let!(:user) { create(:user) }
  let!(:container) { create(:container) }

  before do
    sign_in user
  end

  describe 'deadline_alerts#create & index & destroy' do
    around do |e|
      travel_to('2020-4-10') { e.run }
    end

    context 'when user has deadline_alerts' do
      let!(:p_war) { create(:product_warning) }
      let!(:p_exp) { create(:product_expired) }
      let!(:p_recom) { create(:product_recommend) }

      before do
        visit root_path
      end

      it 'deadline_alerts create successfully' do
        expect(current_path).to eq root_path(user)
        expect(page).to have_button '消費期限をチェック'
        click_button '消費期限をチェック'
        expect(current_path).to eq user_deadline_alerts_path(user)
        expect(page).to have_content '消費期限のチェックが完了しました。'
        within('.breadcrumb') do
          expect(page).to have_content 'Freedger - アラート 一覧'
        end
        within('.deadline_expired') do
          expect(page).to have_content 'Expired'
          expect(page).to have_content "#{p_exp.container.position} - #{p_exp.container.name}"
          expect(page).to have_link p_exp.container.name
          expect(page).to have_content p_exp.name
          expect(page).to have_content "消費期限 - #{p_exp.product_expired_at}"
          expect(page).to have_link 'アラートを削除'
        end
        within('.deadline_warning') do
          expect(page).to have_content 'Warning'
          expect(page).to have_content "#{p_war.container.position} - #{p_war.container.name}"
          expect(page).to have_link p_war.container.name
          expect(page).to have_content p_war.name
          expect(page).to have_content "消費期限 - #{p_war.product_expired_at}"
          expect(page).to have_link 'アラートを削除'
        end
        within('.deadline_recommend') do
          expect(page).to have_content 'Recommend'
          expect(page).to have_content "#{p_recom.container.position} - #{p_recom.container.name}"
          expect(page).to have_link p_recom.container.name
          expect(page).to have_content p_recom.name
          expect(page).to have_content "消費期限 - #{p_recom.product_expired_at}"
          expect(page).to have_link 'アラートを削除'
        end
        visit current_path
        expect(page).not_to have_content '消費期限のチェックが完了しました。'
      end

      it 'deadline_alert delete successfully', js: true do
        click_button '消費期限をチェック'
        expect(current_path).to eq user_deadline_alerts_path(user)
        within('.deadline_expired') do
          expect(page).to have_link 'アラートを削除'
          click_link 'アラートを削除'
        end
        expect(page).not_to have_content '1: Expired'
        within('.deadline_warning') do
          expect(page).to have_content '2: Warning'
        end
        within('.deadline_recommend') do
          expect(page).to have_content '3: Recommend'
        end
      end
    end

    context 'when user has no deadline_alerts' do
      let!(:p_safe) { create(:product_safe) }

      it 'display no alerts found' do
        visit root_path
        click_button '消費期限をチェック'
        expect(page).to have_content '消費期限の近い飲食料品はありません'
      end
    end
  end
end
