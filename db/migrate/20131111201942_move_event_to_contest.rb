class MoveEventToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :name, :string
    add_column :contests, :start_time, :datetime
    add_column :contests, :public, :boolean, default: true
    add_column :contests, :google_event_id, :string

    Contest.reset_column_information

    execute "UPDATE contests c, events e
              SET c.name = e.name,
                  c.start_time = e.start_time,
                  c.public = e.public,
                  c.google_event_id = e.google_id
              WHERE c.id = e.eventable_id"

    drop_table :events
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
