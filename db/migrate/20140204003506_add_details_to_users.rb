class AddDetailsToUsers < ActiveRecord::Migration

class User < ActiveRecord::Base
end
 
def change
  User.reset_column_information
    add_column :users, :run, :string
    add_reference :users, :user_role, index: true
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :integer
    add_column :users, :adress, :string
    add_reference :users, :city, index: true
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    change_column :users, :user_role_id, :integer, :null => false
  end
end
