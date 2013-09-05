# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
bar1 = Bar.create(:name => "Moe's Bar", :token => "8093c64331ab2486")
bar2 = Bar.create(:name => "Bremen", :token => "02227cd8172c7010")

song1 = Song.create(:title => "Don't Look Back In Anger", :artist => "Oasis", :album => "Morning Glory", :price => 1.00, :length => 15)
song2 = Song.create(:title => "Days are Forgotten", :artist => "Kasabian", :album => "Velociraptor", :price => 0.99, :length => 20)
song3 = Song.create(:title => "Something", :artist => "The Beatles", :album => "One", :price => 2.99, :length => 30)

Jukebox.create(:url => "http://0.0.0.0:9292", :bar_id => bar1.id, :volume => 5, :repeat => false, :playlist => "[]", :current_song_index => 0)

Purchase.create(:song => song1, :bar => bar1)
Purchase.create(:song => song2, :bar => bar1)