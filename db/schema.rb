# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130904233139) do

  create_table "bars", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.string   "token",      :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "bars", ["name"], :name => "index_bars_on_name"

  create_table "jukeboxes", :force => true do |t|
    t.string   "url",        :default => "",    :null => false
    t.integer  "bar_id",                        :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "volume",     :default => 0,     :null => false
    t.boolean  "repeat",     :default => false, :null => false
    t.text     "playlist",   :default => ""
  end

  add_index "jukeboxes", ["bar_id"], :name => "index_jukeboxes_on_bar_id"

  create_table "purchases", :force => true do |t|
    t.integer  "song_id",    :null => false
    t.integer  "bar_id",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "purchases", ["bar_id"], :name => "index_purchases_on_bar_id"
  add_index "purchases", ["song_id"], :name => "index_purchases_on_song_id"

  create_table "songs", :force => true do |t|
    t.string   "title",                                    :default => "", :null => false
    t.string   "artist",                                   :default => "", :null => false
    t.string   "album",                                    :default => "", :null => false
    t.decimal  "price",      :precision => 8, :scale => 2
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.integer  "length",                                   :default => 0,  :null => false
  end

end
