class RemoveFaxFromVenues < ActiveRecord::Migration
  def change
    remove_column :venues, :fax, :string
  end
end
