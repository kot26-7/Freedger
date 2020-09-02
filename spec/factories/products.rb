FactoryBot.define do
  factory :product, class: 'Product' do
    sequence(:name) { |n| "Product#{n}" }
    number { 1 }
    product_created_at { '2020-04-04' }
    product_expired_at { '2020-04-05' }
    description { 'this is sample' }
    user_id { 1 }
    container_id { 1 }
  end
end
