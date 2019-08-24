class CreateTransactionStates < ActiveRecord::Migration
  def change
    create_table :transaction_states do |t|
      t.string :name

      t.timestamps
    end
  end
end
