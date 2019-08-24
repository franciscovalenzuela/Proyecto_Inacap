class CreateProducerRoles < ActiveRecord::Migration
  def change
    create_table :producer_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
