class AddGoogleIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :google_id, :string
  end
end
