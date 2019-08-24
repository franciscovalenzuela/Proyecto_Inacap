class CreateProducers < ActiveRecord::Migration
  def change
    create_table :producers do |t|
      t.string :name, :unique => true
      t.string :rut, :unique => true
      t.string :encrypted_password
      t.string :email
      t.string :adress
      t.integer :phone
      t.references :city, index: true
      t.timestamps
    end
  end
end
