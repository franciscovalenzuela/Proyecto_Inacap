class AddAccountIdToProducer < ActiveRecord::Migration
  def change
    add_column :producers, :account_id, :integer
  end
end
