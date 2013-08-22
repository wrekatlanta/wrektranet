class ChangeVenueContactRelationshipOnContact < ActiveRecord::Migration
  def self.up
    drop_table :venue_contacts
    change_table :contacts do |t|
      t.remove :name
      t.remove :phone
      t.remove :notes
      t.references :venue
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
