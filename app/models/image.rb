class Image < ActiveRecord::Base
  #obtiene el atributo "ficticio" (img) de la clase evento, con eso paperclip envia datos en ese atributo"
  belongs_to :event     
  validates_presence_of :event#validar que los campos estan siendo compartidos con Event 
  #accepts_nested_attributes_for :event
  has_attached_file :img, 
   	:path => ":clase/:id_event/:style/:filename",                      
   	:storage => :dropbox,                                       
   	:dropbox_credentials => Rails.root.join("config/dropbox.yml"), 
   	:styles => { :original => "825x300>", :thumb => "300x300>"},
  	:convert_options => {:original => "-quality 50 ", :thumb => "-quality 50 "}
  #before_validation { image.clear if @delete_image }

	def image_thumb
  	img.url(:thumb)
	end

  def image_original
    img.url(:original)
  end

end
