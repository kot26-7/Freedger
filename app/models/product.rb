class Product < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :container
  validates :product_name, presence: true, length: { maximum: 50 }
  validates :product_number, presence: true,
                             numericality: {
                               only_integer: true,
                               greater_than: 0,
                               less_than_or_equal_to: 20,
                             }
  validates :description, length: { maximum: 150 }
  validates :product_created_at, presence: true
  validates :product_expired_at, presence: true
end
