class CreatePsas < ActiveRecord::Migration
  def change
    create_table :psas do |t|
      t.string :title
      t.text :body
      t.string :status
      t.date :expiration_date

      t.timestamps
    end
  end
end
