FactoryBot.define do
  factory :user, class: 'User' do
    id { 1 }
    username { 'test' }
    email { 'TESTtest@example.com' }
    password { 'password' }

    factory :other_user, class: 'User' do
      id { 2 }
      username { 'foobar' }
      email { 'hogehoge@example.com' }
      password { 'password' }
    end
  end
end
