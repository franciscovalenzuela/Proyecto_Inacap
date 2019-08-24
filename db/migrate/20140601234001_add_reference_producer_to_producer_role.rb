class AddReferenceProducerToProducerRole < ActiveRecord::Migration
  def change
    add_reference :producers, :producer_role, :index => true
  end
end
