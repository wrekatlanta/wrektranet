class AddSubscriptionFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :subscribed_to_staff, :boolean
    add_column :users, :subscribed_to_announce, :boolean
  end
end
