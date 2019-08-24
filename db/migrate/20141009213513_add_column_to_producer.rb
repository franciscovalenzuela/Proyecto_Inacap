class AddColumnToProducer < ActiveRecord::Migration
  def change
    add_column :producers, :api_key, :string
  end
end
