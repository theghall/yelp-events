class YelpEvent < ApplicationRecord
  belongs_to :user
  default_scope -> { order(start_date: :desc) }
end
