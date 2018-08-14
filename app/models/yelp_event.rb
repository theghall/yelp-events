class YelpEvent < ApplicationRecord
  belongs_to :user
  default_scope -> { order(start_date: :desc) }
  scope :attending_yes, -> { where(attending: 'yes') }
  scope :attending_maybe, -> { where(attending: 'maybe') }
end
