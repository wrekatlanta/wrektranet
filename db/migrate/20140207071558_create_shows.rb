class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.integer :legacy_id
      t.string :name
      t.string :long_name
      t.string :short_name
      t.string :url
      t.string :description
      t.string :category
      t.string :email
      t.string :facebook
      t.string :twitter

      t.timestamps
    end
  end
end
