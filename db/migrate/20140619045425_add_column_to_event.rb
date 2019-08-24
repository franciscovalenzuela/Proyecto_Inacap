class AddColumnToEvent < ActiveRecord::Migration
  def change
    add_reference :events, :event_status, index: true
    add_column :events, :description, :text
  end
end
