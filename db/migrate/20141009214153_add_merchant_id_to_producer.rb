class AddMerchantIdToProducer < ActiveRecord::Migration
  def change
    add_column :producers, :merchant_id, :integer
  end
end
