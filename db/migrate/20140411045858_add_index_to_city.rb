class AddIndexToCity < ActiveRecord::Migration
  def change
    add_index :cities, :name, name:'city_name' 
  end
end
