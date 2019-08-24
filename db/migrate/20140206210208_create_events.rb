class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.references :producer, index: true
      t.references :city, index: true
      t.string :address
      t.float :latitude
      t.float :longitude
      t.references :event_type, index: true

      t.timestamps
    end
  end
end
