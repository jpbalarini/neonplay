class AddLengthToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :length, :integer, :null => false, :default => 0
  end
end
