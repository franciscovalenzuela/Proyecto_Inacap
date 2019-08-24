class AddIpToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :ip, :string
  end
end
