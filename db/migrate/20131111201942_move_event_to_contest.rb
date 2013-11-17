class MoveEventToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :name, :string
    add_column :contests, :start_time, :datetime
    add_column :contests, :public, :boolean, default: true
    add_column :contests, :google_event_id, :string

    Contest.reset_column_information

    execute "UPDATE contests c
              SET name = e.name,
                  start_time = e.start_time,
                  public = e.public,
                  google_event_id = e.google_id
              FROM events e
              WHERE c.id = e.eventable_id"

    drop_table :events
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
