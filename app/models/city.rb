class City < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  has_many :users
  has_many :producers
  belongs_to :region
end
