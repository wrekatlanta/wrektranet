class RemovePolymorphicContestsFromStaffTicketsAgain < ActiveRecord::Migration
  def self.up
    remove_column :staff_tickets, :contest_type
  end

  def self.down
    add_column :staff_tickets, :contest_type, :string
  end
end
