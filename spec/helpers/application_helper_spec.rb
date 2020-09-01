require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title helper method' do
    it { expect(full_title(nil)).to eq 'Freedger' }
    it { expect(full_title('')).to eq 'Freedger' }
    it { expect(full_title('Home')).to eq 'Home - Freedger' }
  end
end
