class Micropost < ApplicationRecord
  scope :recent, -> {order(created_at: :desc)}
end
