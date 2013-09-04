class AddVolumeAndRepeatToJukebox < ActiveRecord::Migration
  def change
    add_column :jukeboxes, :volume, :integer, :null => false, :default => 0
    add_column :jukeboxes, :repeat, :boolean, :null => false, :default => false
  end
end
