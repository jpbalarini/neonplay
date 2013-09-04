class CreateJukeboxes < ActiveRecord::Migration
  def up
    create_table :jukeboxes do |t|
      t.string :url, :null => false, :default => ""
      t.integer :bar_id, :null => false

      t.timestamps
    end

    add_index :jukeboxes, :bar_id
  end

  def down
    drop_table :jukeboxes
  end
end
