class ChangeDataTypeForCityProducerEventType < ActiveRecord::Migration
class Event < ActiveRecord::Base
end
 
def change
  Event.reset_column_information
    change_column :events, :producer_id, :integer, :null => false
    change_column :events, :city_id, :integer, :null => false
    change_column :events, :event_type_id, :integer, :null => false
  end
end
