class ChangeContestTypeOnContest < ActiveRecord::Migration
  def change
    change_column :staff_tickets, :contest_type, :string
  end
end
