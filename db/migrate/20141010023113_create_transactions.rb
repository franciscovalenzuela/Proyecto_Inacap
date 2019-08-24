class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :reference_code
      t.references :user, index: true
      t.references :section, index: true
      t.references :transaction_state, index: true
      t.integer :quantity
      t.integer :price
      t.string :signature
      t.string :pol_response_code
      t.string :reference_pol
      t.integer :pol_payment_method_type
      t.datetime :processing_date
      t.string :description
      t.string :message
      t.string :merchant_name
      t.string :transaction_id

      t.timestamps
    end
  end
end
