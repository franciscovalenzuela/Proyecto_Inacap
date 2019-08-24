class ChangeDateTypeForRun < ActiveRecord::Migration
class User < ActiveRecord::Base
end
 
def change
  User.reset_column_information
  change_column :users, :run, :string, :unique => true
  end
end
