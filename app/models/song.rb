class Song < ActiveRecord::Base
  attr_accessible :title
  attr_accessible :artist
  attr_accessible :album
  attr_accessible :price

  validates :title, :presence => {:message => "Please enter a title"}, :if => Proc.new { |at| at.title.blank?}
  validates :artist, :presence => {:message => "Please enter an artist"}, :if => Proc.new { |at| at.artist.blank?}
  validates :album, :presence => {:message => "Please enter an album"}, :if => Proc.new { |at| at.album.blank?}
  validates :price, :presence => {:message => "Please enter a price"}, :if => Proc.new { |at| at.price.blank?}

  validates_uniqueness_of :title, :scope => [:artist, :album]
end
