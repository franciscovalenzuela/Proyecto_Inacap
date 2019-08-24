class AddPrincipalToImages < ActiveRecord::Migration
  def change
    add_column :images, :flayer, :boolean, :default => false
  end
end
