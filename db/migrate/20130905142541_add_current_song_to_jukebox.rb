class AddCurrentSongToJukebox < ActiveRecord::Migration
  def change
    add_column :jukeboxes, :current_song_index, :integer, :default => 0
  end
end
