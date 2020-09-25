RSpec.describe Container, type: :model do
  let(:user) { create(:user) }
  let(:container_params) { attributes_for(:container) }

  context 'All params is valid' do
    it 'container is valid' do
      container = user.containers.new(container_params)
      expect(container).to be_valid
      expect(container[:position]).to eq 'Fridge'
    end
  end

  context 'name is invalid' do
    it 'invalid with nil' do
      container = user.containers.new(container_params[name: nil])
      expect(container).to be_invalid
    end

    it 'invalid with empty' do
      container = user.containers.new(container_params[name: ''])
      expect(container).to be_invalid
    end

    it 'invalid with greater than 50 words' do
      container = user.containers.new(container_params[name: 'a' * 51])
      expect(container).to be_invalid
    end
  end

  context 'position is invalid' do
    it 'invalid with nil' do
      container = user.containers.new(container_params[position: nil])
      expect(container).to be_invalid
    end

    it 'invalid with empty' do
      container = user.containers.new(container_params[position: ''])
      expect(container).to be_invalid
    end

    it 'invalid with less than 6 words' do
      container = user.containers.new(container_params[position: 'a' * 5])
      expect(container).to be_invalid
    end

    it 'invalid with greater than 7 words' do
      container = user.containers.new(container_params[position: 'a' * 8])
      expect(container).to be_invalid
    end
  end

  context 'description is invalid' do
    it 'invalid with greater than 150 words' do
      container = user.containers.new(container_params[description: 'a' * 151])
      expect(container).to be_invalid
    end
  end
end
