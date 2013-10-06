class AddPublicToEvent < ActiveRecord::Migration
  def change
    add_column :events, :public, :boolean, default: true
  end
end
