class Container < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy
  mount_uploader :image, ContainerImageUploader
  validates :name, presence: true, length: { maximum: 50 }
  validates :position, presence: true, length: { in: 6..7 }
  validates :description, length: { maximum: 150 }
end
