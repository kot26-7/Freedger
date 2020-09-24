FactoryBot.define do
  factory :container, class: 'Container' do
    sequence(:name) { |n| "Container#{n}" }
    description { 'this is sample container' }
    user_id { 1 }
  end

  factory :other_container, class: 'Container' do
    name { 'Container_other_user' }
    description { 'this is sample other_container' }
    user_id { 2 }
  end
end
