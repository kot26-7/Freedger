require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title helper method' do
    it { expect(full_title(nil)).to eq 'Freedger' }
    it { expect(full_title('')).to eq 'Freedger' }
    it { expect(full_title('Home')).to eq 'Home - Freedger' }
  end

  describe '#alert_define helper method' do
    let!(:user) { create(:user) }
    let!(:container) { create(:container) }
    let!(:products) { create_list(:product, 3) }
    let(:deadline_rec) { create(:deadline_alert) }
    let(:deadline_war) { create(:deadline_alert_war) }
    let(:deadline_exp) { create(:deadline_alert_exp) }

    it { expect(alert_define(deadline_exp)).to eq 'deadline_expired' }
    it { expect(alert_define(deadline_war)).to eq 'deadline_warning' }
    it { expect(alert_define(deadline_rec)).to eq 'deadline_recommend' }
  end
end
