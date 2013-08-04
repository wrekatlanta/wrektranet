class CreateVenueContacts < ActiveRecord::Migration
  def change
    create_table :venue_contacts, :id => false do |t|
      t.references :venue, index: true
      t.references :contact, index: true

      t.timestamps
    end
  end

  def self.up
    add_index :venue_contacts, [:venue_id, :contact_id], :unique => true
  end

  def self.down
    remove_index :venue_contacts, [:venue_id, :contact_id]
  end
end
