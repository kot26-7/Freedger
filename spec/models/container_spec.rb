RSpec.describe Container, type: :model do
  let(:user) { create(:user) }

  context 'All params is correct' do
    it 'container is valid' do
      container = user.containers.new(name: 'hogehoge',
                                      description: 'this is sample',
                                      user_id: 1)
      expect(container).to be_valid
      expect(container[:position]).to eq 'Fridge'
    end
  end

  context 'name is uncorrect' do
    it 'invalid with nil' do
      container = user.containers.new(name: nil,
                                      description: 'this is sample',
                                      user_id: 1)
      expect(container).to be_invalid
    end

    it 'invalid with blank' do
      container = user.containers.new(name: '',
                                      description: 'this is sample',
                                      user_id: 1)
      expect(container).to be_invalid
    end

    it 'invalid with over 50 words' do
      container = user.containers.new(name: 'a' * 51,
                                      description: 'this is sample',
                                      user_id: 1)
      expect(container).to be_invalid
    end
  end

  context 'position is uncorrect' do
    it 'invalid with nil' do
      container = user.containers.new(name: 'hogehoge', position: nil,
                                      description: 'this is sample', user_id: 1)
      expect(container).to be_invalid
    end

    it 'invalid with blank' do
      container = user.containers.new(name: 'hogehoge', position: '',
                                      description: 'this is sample', user_id: 1)
      expect(container).to be_invalid
    end

    it 'invalid with under 6 words' do
      container = user.containers.new(name: 'hogehoge', position: 'a' * 5,
                                      description: 'this is sample', user_id: 1)
      expect(container).to be_invalid
    end

    it 'invalid with over 7 words' do
      container = user.containers.new(name: 'hogehoge', position: 'a' * 8,
                                      description: 'this is sample', user_id: 1)
      expect(container).to be_invalid
    end
  end

  context 'description is uncorrect' do
    it 'invalid with over 150 words' do
      container = user.containers.new(name: 'a' * 51,
                                      description: 'a' * 151,
                                      user_id: 1)
      expect(container).to be_invalid
    end
  end
end
