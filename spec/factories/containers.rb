FactoryBot.define do
  factory :container, class: 'Container' do
    sequence(:name) { |n| "Container#{n}" }
    description { 'this is sample container' }
    user_id { 1 }
  end

  factory :container2, class: 'Container' do
    name { 'Container_user2' }
    description { 'this is sample container2' }
    user_id { 2 }
  end
end
