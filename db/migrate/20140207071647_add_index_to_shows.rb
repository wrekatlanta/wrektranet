class AddIndexToShows < ActiveRecord::Migration
  def change
    add_index :shows, :legacy_id, unique: true
  end
end
