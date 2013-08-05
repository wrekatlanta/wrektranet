class RemovePolymorphicContestsFromStaffTickets < ActiveRecord::Migration
  def self.up
    remove_column :staff_tickets, :contest_type
  end

  def self.down
    add_column :staff_tickets, :contest_type, :string
  end

  def change
    change_table :contest_suggestions do |t|
      t.references :user, index: true
      t.boolean :archived, default: false
    end
  end
end
