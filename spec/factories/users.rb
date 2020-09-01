FactoryBot.define do
  factory :user, class: 'User' do
    id { 1 }
    username { 'test' }
    email { 'TESTtest@example.com' }
    password { 'password' }
  end

  factory :other_user, class: 'User' do
    id { 2 }
    username { 'foobar' }
    email { 'TESThoge@example.com' }
    password { 'password' }
  end
end
