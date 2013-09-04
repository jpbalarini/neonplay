class AddPlaylistToJukebox < ActiveRecord::Migration
  def change
    add_column :jukeboxes, :playlist, :text, :default => ""
  end
end
