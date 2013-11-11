class MoveEventToContest < ActiveRecord::Migration
  def self.up
    add_column :contests, :name, :string
    add_column :contests, :start_time, :datetime
    add_column :contests, :public, :boolean, default: true
    add_column :contests, :google_event_id, :string

    Contest.reset_column_information

    Contest.find_each do |contest|
      contest.name = contest.event.name
      contest.start_time = contest.event.start_time
      contest.public = contest.event.public
      contest.google_event_id = contest.event.google_id
      contest.save!
    end

    drop_table :events
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
