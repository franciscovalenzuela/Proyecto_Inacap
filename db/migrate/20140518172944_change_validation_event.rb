class ChangeValidationEvent < ActiveRecord::Migration
 class Event < ActiveRecord::Base
 end
   
 def change
   Event.reset_column_information
    change_column :events, :name, :string, :limit => 45, :null => false
    change_column :events, :address, :string, :limit => 45, :null => false
    change_column :events, :date, :datetime, :null => false
 end
end
