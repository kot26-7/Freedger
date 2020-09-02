RSpec.describe User, type: :model do
  let(:user_params) { attributes_for(:user) }

  context 'All params is correct' do
    it 'user is valid' do
      user = User.new(user_params)
      expect(user).to be_valid
    end
  end

  context 'username is uncorrect' do
    it 'blank username is invalid' do
      user = User.new(user_params[username: ''])
      expect(user).to be_invalid
    end

    it 'nil username is invalid' do
      user = User.new(user_params[username: nil])
      expect(user).to be_invalid
    end

    it 'username with . is invalid' do
      user = User.new(user_params[username: 'hoge.hoge'])
      expect(user).to be_invalid
    end

    it 'username over 51 is invalid' do
      user = User.new(user_params[username: 'a' * 51])
      expect(user).to be_invalid
    end
  end

  context 'email is uncorrect' do
    it 'blank email is invalid' do
      user = User.new(user_params[email: ''])
      expect(user).to be_invalid
    end

    it 'nil email is invalid' do
      user = User.new(user_params[email: nil])
      expect(user).to be_invalid
    end

    it 'short email is invalid' do
      user = User.new(user_params[email: 'ho@ga'])
      expect(user).to be_invalid
    end
  end

  context 'password is uncorrect' do
    it 'blank password is invalid' do
      user = User.new(user_params[password: ''])
      expect(user).to be_invalid
    end

    it 'nil password is invalid' do
      user = User.new(user_params[password: nil])
      expect(user).to be_invalid
    end

    it 'password under 6 is invalid' do
      user = User.new(user_params[password: 'faaff'])
      expect(user).to be_invalid
    end
  end
end
