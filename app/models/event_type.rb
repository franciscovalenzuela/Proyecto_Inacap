class EventType < ActiveRecord::Base
  has_many :events

  def to_param
    "#{id}-#{name}".parameterize
  end
  
end
