class AddExecStaffToUser < ActiveRecord::Migration
  def up
    #add_column :users, :exec_staff, :boolean, default: false

    # User.with_role(:exec).each do |user|
    #   user.exec_staff = true
    #   user.save!
    # end

    # r = Role.find_by(name: "exec")

    # r.destroy! unless r.blank?
  end

  def down
    remove_column :users, :exec_staff
  end
end
