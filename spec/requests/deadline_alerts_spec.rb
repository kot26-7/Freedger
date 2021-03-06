require 'rails_helper'

RSpec.describe 'DeadlineAlerts', type: :request do
  let!(:user) { create(:user) }
  let!(:container) { create(:container) }

  context 'when sign_in' do
    before do
      sign_in user
      get root_path
    end

    describe 'deadline_alerts#index' do
      let!(:products) { create_list(:product, 3) }
      let!(:deadline_rec) { create(:deadline_alert) }
      let!(:deadline_war) { create(:deadline_alert_war) }
      let!(:deadline_exp) { create(:deadline_alert_exp) }

      before do
        get user_deadline_alerts_path(user)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end

      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'displayed on correct title' do
        expect(response.body).to include full_title('アラート 一覧')
      end
    end

    describe 'deadline_alerts#create' do
      let!(:product_warning) { create(:product_warning) }
      let!(:product_expired) { create(:product_expired) }
      let!(:product_recommend) { create(:product_recommend) }

      around do |e|
        travel_to('2020-04-10') { e.run }
      end

      it 'create http has 302' do
        post user_deadline_alerts_path(user)
        expect(response.status).to eq 302
      end

      it 'create action has success' do
        expect do
          post user_deadline_alerts_path(user)
        end.to change(user.deadline_alerts, :count).by 3
      end

      it 'redirects to user_deadline_alerts_path' do
        post user_deadline_alerts_path(user)
        expect(response).to redirect_to user_deadline_alerts_path(user)
      end

      it 'deadline_alerts.first.action is Warning' do
        post user_deadline_alerts_path(user)
        expect(DeadlineAlert.all.first[:action]).to eq Settings.deadline_warning
      end

      it 'deadline_alerts.second.action is Expired' do
        post user_deadline_alerts_path(user)
        expect(DeadlineAlert.all.second[:action]).to eq Settings.deadline_expired
      end

      it 'deadline_alerts.third.action is Expired' do
        post user_deadline_alerts_path(user)
        expect(DeadlineAlert.all.third[:action]).to eq Settings.deadline_recommend
      end
    end

    describe 'deadline_alerts#destroy' do
      let!(:product) { create(:product) }
      let!(:deadline_alert) { create(:deadline_alert) }

      it 'destroy http has success' do
        delete user_deadline_alert_path(user, deadline_alert), xhr: true
        expect(response.status).to eq 200
      end

      it 'deletes an deadline_alert' do
        expect do
          delete user_deadline_alert_path(user, deadline_alert), xhr: true
        end.to change(DeadlineAlert, :count).by(-1)
      end
    end
  end

  context 'when not sign_in' do
    before do
      get root_path
    end

    describe 'deadline_alerts#index' do
      let!(:products) { create_list(:product, 3) }
      let!(:deadline_rec) { create(:deadline_alert) }
      let!(:deadline_war) { create(:deadline_alert_war) }
      let!(:deadline_exp) { create(:deadline_alert_exp) }

      it 'going to login page' do
        get user_deadline_alerts_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'deadline_alerts#create' do
      let!(:product_warning) { create(:product_warning) }
      let!(:product_expired) { create(:product_expired) }
      let!(:product_recommend) { create(:product_recommend) }

      around do |e|
        travel_to('2020-04-10') { e.run }
      end

      it 'going to login page' do
        post user_deadline_alerts_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'deadline_alerts#destroy' do
      let!(:product) { create(:product) }
      let!(:deadline_alert) { create(:deadline_alert) }

      it 'going to login page' do
        delete user_deadline_alert_path(user, deadline_alert)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
