class AddSponsorToEvent < ActiveRecord::Migration
  def change
    add_column :events, :sponsor, :boolean, :default => false
  end
end
