class Section < ActiveRecord::Base
  belongs_to :event
  has_many :tickets
  before_create :gratuito
  def gratuito
    self.price ||= 0
  end
end
