class User < ApplicationRecord
  has_many :containers, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :container_products, through: :containers, source: :products
  has_many :deadline_alerts, dependent: :destroy
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_]+\z/.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :username, presence: true, length: { maximum: 50 },
                       format: { with: VALID_USERNAME_REGEX }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
