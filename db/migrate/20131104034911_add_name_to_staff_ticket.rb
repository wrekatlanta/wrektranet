class AddNameToStaffTicket < ActiveRecord::Migration
  def change
    add_column :staff_tickets, :display_name, :string
  end
end
