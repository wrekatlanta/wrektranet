class AddUserFields < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string   :username,                :null => false
      t.string   :phone
      t.string   :first_name
      t.string   :last_name
      t.string   :display_name
      t.string   :status
      t.boolean  :admin
      t.integer  :buzzcard_id
      t.integer  :buzzcard_facility_code
    end

    add_index :users, :username, :unique => true
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
