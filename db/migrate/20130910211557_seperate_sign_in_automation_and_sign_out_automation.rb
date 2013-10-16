class SeperateSignInAutomationAndSignOutAutomation < ActiveRecord::Migration
  def change
    remove_column :transmitter_log_entries, :automation, :boolean
    add_column :transmitter_log_entries, :automation_in, :boolean, default: false
    add_column :transmitter_log_entries, :automation_out, :boolean, default: false
  end
end
