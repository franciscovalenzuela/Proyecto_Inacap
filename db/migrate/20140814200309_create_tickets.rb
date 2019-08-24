class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :section, index: true
      t.boolean :state
      t.string :qr

      t.timestamps
    end
  end
end
