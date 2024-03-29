class AddAttachmentAvatarToProducers < ActiveRecord::Migration
  def self.up
    change_table :producers do |t|
      t.attachment :avatar
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end
    add_index :producers, :email,                :unique => true
    add_index :producers, :reset_password_token, :unique => true
  end

  def self.down
    drop_attached_file :producers, :avatar
  end
end
