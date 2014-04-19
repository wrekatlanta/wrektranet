class AddExecStaffToUser < ActiveRecord::Migration
  def up
    add_column :users, :exec_staff, :boolean, default: false

    User.with_role(:exec).each do |user|
      user.remove_role :exec
      user.exec_staff = true
      user.save
    end

    Role.find_by(name: "exec").try(:destroy)
  end

  def down
    remove_column :users, :exec_staff
  end
end
