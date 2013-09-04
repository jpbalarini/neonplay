class CreateSongs < ActiveRecord::Migration
  def up
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :album
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def down
    drop_table :songs
  end
end
