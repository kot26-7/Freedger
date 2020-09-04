RSpec.describe DeadlineAlert, type: :model do
  let!(:user) { create(:user) }
  let!(:container) { create(:container) }
  let!(:product) { create(:product) }
  let(:deadline_alert_params) { attributes_for(:deadline_alert) }

  context 'All params is correct' do
    it 'deadline_alert is valid' do
      deadline = DeadlineAlert.new(deadline_alert_params)
      expect(deadline).to be_valid
    end
  end

  context 'action is uncorrect' do
    it 'invalid with action nil' do
      deadline = DeadlineAlert.new(deadline_alert_params[action: nil])
      expect(deadline).to be_invalid
    end

    it 'invalid with action empty' do
      deadline = DeadlineAlert.new(deadline_alert_params[action: ''])
      expect(deadline).to be_invalid
    end

    it 'invalid with action less than 7' do
      deadline = DeadlineAlert.new(deadline_alert_params[action: 'a' * 6])
      expect(deadline).to be_invalid
    end

    it 'invalid with action greater than 9' do
      deadline = DeadlineAlert.new(deadline_alert_params[action: 'a' * 10])
      expect(deadline).to be_invalid
    end
  end
end
