class CreateBars < ActiveRecord::Migration
  def up
    create_table :bars do |t|
      t.string :name, :null => false, :default => ""
      t.string :token, :null => false, :default => ""

      t.timestamps
    end

    add_index :bars, :name
  end

  def down
    drop_table :bars
  end
end
