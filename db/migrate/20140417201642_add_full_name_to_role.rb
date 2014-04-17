class AddFullNameToRole < ActiveRecord::Migration
  def change
    add_column :roles, :full_name, :string
  end
end
