class CreateLegacyBases < ActiveRecord::Migration
  def change
    create_table :legacy_bases do |t|

      t.timestamps
    end
  end
end
