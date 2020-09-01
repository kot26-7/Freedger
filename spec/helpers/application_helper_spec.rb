require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title helper method' do
    it { expect(full_title(nil)).to eq 'My_app' }
    it { expect(full_title('')).to eq 'My_app' }
    it { expect(full_title('Home')).to eq 'Home - My_app' }
  end
end
