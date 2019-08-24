class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
  belongs_to :transaction_state
end
