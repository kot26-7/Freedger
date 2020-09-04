FactoryBot.define do
  factory :deadline_alert, class: 'DeadlineAlert' do
    user_id { 1 }
    container_id { 1 }
    product_id { 1 }
    action { 'Recommend' }

    factory :deadline_alert_war, class: 'DeadlineAlert' do
      product_id { 2 }
      action { 'Warning' }
    end

    factory :deadline_alert_exp, class: 'DeadlineAlert' do
      product_id { 3 }
      action { 'Expired' }
    end
  end
end
