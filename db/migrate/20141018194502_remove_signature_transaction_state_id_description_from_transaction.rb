class RemoveSignatureTransactionStateIdDescriptionFromTransaction < ActiveRecord::Migration
  def change
    remove_reference :transactions, :transaction_state, index: true
    remove_column :transactions, :signature, :string
    remove_column :transactions, :description, :string
  end
end
