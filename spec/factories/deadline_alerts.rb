FactoryBot.define do
  factory :deadline_alert do
    user_id { 1 }
    container_id { 1 }
    product_id { 1 }
    action { 'Recommend' }
  end
end
