class RemoveGoogleEventIdFromContest < ActiveRecord::Migration
  def up
    remove_column :contests, :google_event_id, :string
  end

  def down
    add_column :contests, :google_event_id, :string
  end
end
