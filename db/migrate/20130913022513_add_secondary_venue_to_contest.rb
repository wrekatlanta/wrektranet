class AddSecondaryVenueToContest < ActiveRecord::Migration
  def change
    add_reference :contests, :recipient, index: true
    change_column :staff_tickets, :awarded, :boolean, default: false
    change_column :users, :admin, :boolean, default: false
  end
end
