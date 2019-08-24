class User < ActiveRecord::Base
  belongs_to :city
  belongs_to :user_role
  has_many :transactions

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
	
  before_create :rol_defecto
  has_attached_file :avatar, 
  :path => ":class/:id/:style/:filename",                      
  :storage => :dropbox,                                       
  :dropbox_credentials => Rails.root.join("config/dropbox.yml"), 
  :styles => { :original => "300x300>" },
  :convert_options => {:original => "-quality 50 "},
  :default_url => "/images/Default_avatar.png"
  before_post_process :definir_formato

  #obtiene rol de usuario logeado y compara los roles que hay con el del recien logeado( en formato symbol, osea :rol1 == :rol2)
  def has_role?(role_sym)
    if self.user_role.name.downcase.to_sym == role_sym.downcase
      return true
    else
      return false
    end
  end 

  def rol_defecto
    self.user_role ||= UserRole.find_by_name('Normal')
  end

  def self.from_omniauth(auth)
      where(auth.slice(:provider, :uid)).first_or_create do |user|
	case user.provider
	when "facebook"
         user.provider = auth.provider
         user.uid = auth.uid
         user.email = auth.info.email
         user.name = auth.info.nickname
	 user.avatar = URI.parse(auth.info.image) if auth.info.image?
	when "twitter"
         user.provider = auth.provider
         user.uid = auth.uid
         user.name = auth.info.nickname
	 user.avatar = URI.parse(auth.info.image) if auth.info.image?
	when "google_oauth2"
         user.provider = auth.provider
         user.uid = auth.uid
         user.email = auth.info.email
         user.name = auth.info.name
	 user.avatar = URI.parse(auth.info.image) if auth.info.image?
	else
	 puts "no paso nada"
	end
      end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new session["devise.user_attributes"] do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def email_required?
    super && provider.blank?
  end


 def password_required?
    super && provider.blank?
 end


  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def definir_formato
    extension = 'jpg'
    filename = avatar_file_name
    if self.provider == "facebook"
      self.avatar.instance_write(:file_name, "#{filename}.#{extension}")
    end
  end
end
