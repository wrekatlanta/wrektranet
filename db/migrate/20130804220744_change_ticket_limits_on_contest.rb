class ChangeTicketLimitsOnContest < ActiveRecord::Migration
  def change
    rename_column :contests, :staff_tickets, :staff_ticket_limit
    rename_column :contests, :listener_tickets, :listener_ticket_limit
  end
end
