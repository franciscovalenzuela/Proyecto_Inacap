Paperclip.interpolates :clase do |attachment, style|
   attachment.instance.event.class.name.pluralize.downcase  
end
Paperclip.interpolates('id_event') do |attachment, style|
   attachment.instance.event.id
end 

