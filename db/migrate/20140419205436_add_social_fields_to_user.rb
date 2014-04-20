class AddSocialFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook, :string
    add_column :users, :spotify, :string
    add_column :users, :lastfm, :string
  end
end
