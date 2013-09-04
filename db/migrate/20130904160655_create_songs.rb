class CreateSongs < ActiveRecord::Migration
  def up
    create_table :songs do |t|
      t.string :title, :null => false, :default => ""
      t.string :artist, :null => false, :default => ""
      t.string :album, :null => false, :default => ""
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def down
    drop_table :songs
  end
end
