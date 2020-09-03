class DeadlineAlert < ApplicationRecord
  belongs_to :user
  belongs_to :container
  belongs_to :product
end
