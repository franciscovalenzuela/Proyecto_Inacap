class Event < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders] 

  #before_save :slugify_name

  is_impressionable
  belongs_to :producer
  belongs_to :city
  belongs_to :event_type
  belongs_to :event_status
  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  has_many :sections
  before_create :default_status
  validates :name, uniqueness: true

  def section_list
    sections.map { |x| [x.id, x.name, x.stock, x.price] }
  end

  def thumb_url
  	images.select { |i| i.flayer == true }.map(&:image_thumb)
	end

  def original_url
    images.select { |i| i.flayer == true }.map(&:image_original)
  end

  def original_urls
    images.map(&:image_original)
  end

  def default_status
    self.event_status||= EventStatus.find_by_name('Activo')
  end

  def slugify_name
    self.name = name.parameterize
  end
  
  def should_generate_new_friendly_id?
    name_changed?
  end
end
