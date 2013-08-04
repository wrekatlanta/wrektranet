class AddPlusOneToContest < ActiveRecord::Migration
  def change
    add_column :contests, :listener_plus_one, :boolean
    add_column :contests, :staff_plus_one, :boolean
  end
end
