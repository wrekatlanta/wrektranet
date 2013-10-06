class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :eventable, polymorphic: true, index: true
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :all_day, default: false

      t.timestamps
    end
  end
end
