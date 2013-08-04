class CreateStaffTickets < ActiveRecord::Migration
  def change
    create_table :staff_tickets do |t|
      t.references :user, index: true
      t.integer :contest_id
      t.integer :contest_type
      t.integer :contest_director_id
      t.boolean :awarded

      t.timestamps
    end
  end
end
