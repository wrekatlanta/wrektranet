class AddCounterCachesToContest < ActiveRecord::Migration
  def change
    add_column :contests, :staff_count, :integer
    add_column :contests, :listener_count, :integer
  end
end
