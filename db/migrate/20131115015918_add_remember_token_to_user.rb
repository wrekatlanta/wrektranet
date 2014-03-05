class AddRememberTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :remember_token, :string
  end

  def self.down
  end
end
