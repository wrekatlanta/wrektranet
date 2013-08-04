class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :name
      t.datetime :date
      t.references :venue, index: true
      t.integer :age_limit
      t.boolean :pick_up
      t.integer :listener_tickets
      t.integer :staff_tickets
      t.text :notes

      t.timestamps
    end
  end
end
