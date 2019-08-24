
#country
c = Country.create(name: 'Chile')

#region
r = Region.create(name: 'Los Lagos', country_id: c.id )

#cities

city_list = [
 ["Osorno", -40.57450, -73.131920],
 ["Puerto Montt", -41.471699, -72.936897],
 ["Puerto Varas", -41.316700, -72.983299],
 ["Maullin", -41.614807, -73.599030],
 ["Calbuco", -41.772015, -73.132706],
 ["Frutillar", -41.116669, -73.050003],
 ["Llanquihue", -41.260632, -73.007843],
 ["Ancud",  -41.867500, -73.827698],
 ["Castro", -42.480141, -73.762413],
]

city_list.each do |name, latitude, longitude|
  City.create( name: name, region_id: r.id, latitude: latitude, longitude: longitude)
end

# UserRole
['Admin', 'Normal'].each do |role|
	UserRole.find_or_create_by_name role
end

# ProducerRole
['Gold', 'Silver'].each do |role|
       ProducerRole.find_or_create_by_name role
end


#admin
user = User.create! :name => 'admin', :email => 'admin@test.cl', :password => 'contraseña', :password_confirmation => 'contraseña', :user_role_id => 1


#eventtype
etype_list = 
["Teatro", "Conferencia", "Concierto", "Deporte", "Tradicional", "Tocata"] 

etype_list.each do |name|
  EventType.create( name: name)
end

#estados
status_list = 
["Activo", "Cancelado", "Suspendido"] 

status_list.each do |name|
  EventStatus.create( name: name)
end

#user = User.create! :name => 'Sebastian', :email => 'sebastian@test.cl', :password => 'contraseña', :password_confirmation => 'contraseña', :user_role_id => 2