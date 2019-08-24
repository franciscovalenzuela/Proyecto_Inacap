class ActiveSupport::TimeWithZone
  def as_json(options={})
    strftime('%d de %B %Y %H:%M horas')
  end
end