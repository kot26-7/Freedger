RSpec.describe User, type: :model do
  context 'All params is correct' do
    it 'user is valid' do
      user = User.new(username: 'hogehoge', email: 'foobar@example.com', password: 'password')
      expect(user).to be_valid
    end

    it 'user with upcase is valid' do
      user = User.new(username: 'HogeHoge', email: 'FOOBAR@example.com', password: 'Password')
      expect(user).to be_valid
    end
  end

  context 'username is uncorrect' do
    it 'blank username is invalid' do
      user = User.new(username: '', email: 'foobar@example.com', password: 'password')
      expect(user).to be_invalid
    end

    it 'nil username is invalid' do
      user = User.new(username: nil, email: 'foobar@example.com', password: 'password')
      expect(user).to be_invalid
    end

    it 'username with . is invalid' do
      user = User.new(username: 'hoge.hoge', email: 'foobar@example.com', password: 'password')
      expect(user).to be_invalid
    end

    it 'username over 51 is invalid' do
      user = User.new(username: 'a' * 51, email: 'foobar@example.com', password: 'password')
      expect(user).to be_invalid
    end
  end

  context 'email is uncorrect' do
    it 'blank email is invalid' do
      user = User.new(username: 'hogehoge', email: '', password: 'password')
      expect(user).to be_invalid
    end

    it 'nil email is invalid' do
      user = User.new(username: 'hogehoge', email: nil, password: 'password')
      expect(user).to be_invalid
    end

    it 'short email is invalid' do
      user = User.new(username: 'hogehoge', email: 'ho@ga', password: 'password')
      expect(user).to be_invalid
    end
  end

  context 'password is uncorrect' do
    it 'blank password is invalid' do
      user = User.new(username: 'hogehoge', email: 'foobar@example.com', password: '')
      expect(user).to be_invalid
    end

    it 'nil password is invalid' do
      user = User.new(username: 'hogehoge', email: 'foobar@example.com', password: nil)
      expect(user).to be_invalid
    end

    it 'password under 6 is invalid' do
      user = User.new(username: 'hogehoge', email: 'foobar@example.com', password: 'Fooo1')
      expect(user).to be_invalid
    end
  end
end
