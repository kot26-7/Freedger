FactoryBot.define do
  factory :product, class: 'Product' do
    sequence(:name) { |n| "Product#{n}" }
    number { 1 }
    product_created_at { '2020-04-04' }
    product_expired_at { '2020-04-05' }
    description { 'this is sample' }
    user_id { 1 }
    container_id { 1 }

    factory :product_warning, class: 'Product' do
      sequence(:name) { |n| "war product#{n}" }
      product_created_at { '2020-04-04' }
      product_expired_at { '2020-04-10' }
    end

    factory :product_expired, class: 'Product' do
      sequence(:name) { |n| "exp product#{n}" }
      product_created_at { '2020-04-04' }
      product_expired_at { '2020-04-09' }
    end

    factory :product_recommend, class: 'Product' do
      sequence(:name) { |n| "rec product#{n}" }
      product_created_at { '2020-04-04' }
      product_expired_at { '2020-04-12' }
    end
  end
end
