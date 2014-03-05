class AddLegacyIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :legacy_id, :integer
    add_index :users, :legacy_id, unique: true
  end
end
