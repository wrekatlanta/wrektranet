class RecreateLegacyIdIndexOnUser < ActiveRecord::Migration
  def up
    remove_index :users, :legacy_id
    add_index :users, :legacy_id # not unique
  end

  def down
    add_index :users, :legacy_id, unique: true
  end
end
