class DeadlineAlert < ApplicationRecord
  belongs_to :user
  belongs_to :container
  belongs_to :product
  validates :action, presence: true, length: { in: 10..12 }
end
