class CreatePurchases < ActiveRecord::Migration
  def up
    create_table :purchases do |t|
      t.integer :song_id, :null => false
      t.integer :bar_id, :null => false

      t.timestamps
    end

    add_index :purchases, :song_id
    add_index :purchases, :bar_id
  end

  def down
    drop_table :purchases
  end
end
