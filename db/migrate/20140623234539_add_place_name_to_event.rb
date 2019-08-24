class AddPlaceNameToEvent < ActiveRecord::Migration
  def change
    add_column :events, :place_name, :string
  end
end
