class Producer < ActiveRecord::Base
  
  has_many :events, :dependent => :destroy
  belongs_to :city
  belongs_to :producer_role
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_create :rol_defecto
  has_attached_file :avatar, 
    :path => ":class/:id/:style/:filename",                      
   :storage => :dropbox,                                       
    :dropbox_credentials => Rails.root.join("config/dropbox.yml"), 
    :styles => { :original => "300x300>" },
    :convert_options => {:original => "-quality 50 "},
    :default_url => "/images/Default_avatar.png"

  def has_rolep(role_sym)
     #producer_role { |r| r.name.downcase.to_sym == role_sym.downcase } 
#FIXME
    if producer_role.name.downcase.to_sym == role_sym.downcase
      return true
    else
      return false
    end
  end 
  private
  def rol_defecto
    self.producer_role ||= ProducerRole.find_by_name('Silver')
  end
end
