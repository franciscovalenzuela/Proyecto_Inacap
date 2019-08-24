class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :img_file_name, :limit => 45
      t.references :event, index: true

      t.timestamps
    end
  end
end
