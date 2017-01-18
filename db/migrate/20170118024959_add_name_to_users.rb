class AddNameToUsers < ActiveRecord::Migration
  def up
    add_column :users, :name, :text, :unique => true, :null => false
  end

  def down
    remove_column :users, :name
  end
end
