class CreateListenerTickets < ActiveRecord::Migration
  def change
    create_table :listener_tickets do |t|
      t.string :name
      t.string :phone
      t.references :contest, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
