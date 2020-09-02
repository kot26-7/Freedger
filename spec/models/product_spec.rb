RSpec.describe Product, type: :model do
  let!(:user) { create(:user) }
  let(:container) { create(:container) }
  let(:product_params) { attributes_for(:product) }

  context 'All params is correct' do
    it 'product is valid' do
      product = container.products.new(product_params)
      expect(product).to be_valid
    end
  end

  context 'name is uncorrect' do
    it 'name is invalid with nil' do
      product = container.products.new(product_params[name: nil])
      expect(product).to be_invalid
    end

    it 'name is invalid with empty' do
      product = container.products.new(product_params[name: ''])
      expect(product).to be_invalid
    end

    it 'product_name is invalid with greater than 50' do
      product = container.products.new(product_params[name: 'a' * 51])
      expect(product).to be_invalid
    end
  end

  context 'number is uncorrect' do
    it 'number is invalid with nil' do
      product = container.products.new(product_params[number: nil])
      expect(product).to be_invalid
    end

    it 'number is invalid with empty' do
      product = container.products.new(product_params[number: ''])
      expect(product).to be_invalid
    end

    it 'product_number is invalid with less than 1' do
      product = container.products.new(product_params[number: 0])
      expect(product).to be_invalid
    end

    it 'product_number is invalid with greater than 20' do
      product = container.products.new(product_params[number: 21])
      expect(product).to be_invalid
    end
  end

  context 'product_created_at is uncorrect' do
    it 'product_created_at is invalid with nil' do
      product = container.products.new(product_params[product_created_at: nil])
      expect(product).to be_invalid
    end

    it 'product_created_at is invalid with empty' do
      product = container.products.new(product_params[product_created_at: ''])
      expect(product).to be_invalid
    end
  end

  context 'product_expired_at is uncorrect' do
    it 'product_expired_at is invalid with nil' do
      product = container.products.new(product_params[product_expired_at: nil])
      expect(product).to be_invalid
    end

    it 'product_expired_at is invalid with empty' do
      product = container.products.new(product_params[product_expired_at: ''])
      expect(product).to be_invalid
    end
  end

  context 'description is uncorrect' do
    it 'description is invalid with greater than 150' do
      product = container.products.new(product_params[description: 'a' * 151])
      expect(product).to be_invalid
    end
  end
end
