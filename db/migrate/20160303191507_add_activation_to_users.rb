class AddActivationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activation_digest, :string
    add_column :users, :activated, :Boolean
    add_column :users, :activated_at, :datetime
  end
end
