class AddExecStaffToUser < ActiveRecord::Migration
  def change
    add_column :users, :exec_staff, :boolean, default: false
  end

  def down
    remove_column :users, :exec_staff
  end
end
