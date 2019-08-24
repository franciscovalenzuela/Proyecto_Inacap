class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.integer :price
      t.datetime :from
      t.datetime :to
      t.boolean :state
      t.integer :stock
      t.references :event, index: true

      t.timestamps
    end
  end
end
