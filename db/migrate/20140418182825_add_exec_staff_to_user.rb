class AddExecStaffToUser < ActiveRecord::Migration
  def change
    add_column :users, :exec_staff, :boolean
  end
end
