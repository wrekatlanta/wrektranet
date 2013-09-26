class ChangeMoreDefaults < ActiveRecord::Migration
  def change
    change_column :contests, :listener_plus_one, :boolean, default: false
    change_column :contests, :staff_plus_one, :boolean, default: false
  end
end
