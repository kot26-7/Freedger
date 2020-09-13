class Product < ApplicationRecord
  belongs_to :user
  belongs_to :container
  has_one :deadline_alert, dependent: :destroy
  acts_as_taggable
  validates :name, presence: true, length: { maximum: 50 }
  validates :number, presence: true,
                     numericality: {
                       only_integer: true,
                       greater_than: 0,
                       less_than_or_equal_to: 20,
                     }
  validates :description, length: { maximum: 150 }
  validates :product_created_at, presence: true
  validates :product_expired_at, presence: true

  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      all
    end
  end
end
